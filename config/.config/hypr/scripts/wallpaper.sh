#!/usr/bin/env bash
# Uso: wallpaper.sh select | random | restore
# Wallpaper con awww (como ViegPhunt): transicion animada al cambiar.
set -euo pipefail

dir="$HOME/dotfiles/wallpapers"
default="$dir/misty-seascape.jpg"
# Symlink a la eleccion actual: lo lee restore al iniciar sesion y lo usa hyprlock.
state="$HOME/.local/state/hypr/current-wallpaper"

wait_daemon() {
  # awww-daemon arranca en paralelo (autostart): esperar a que responda.
  for _ in $(seq 1 20); do
    awww query >/dev/null 2>&1 && return 0
    sleep 0.5
  done
  return 1
}

apply() {
  local img="$1" transition="${2:-any}"
  mkdir -p "${state%/*}"
  ln -sfn "$img" "$state"
  wait_daemon || { notify-send "Wallpaper" "awww-daemon no responde"; exit 1; }
  awww img "$img" --transition-type "$transition" --transition-duration 2 --transition-fps 60
}

mapfile -t files < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)

case "${1:-select}" in
  random)
    (( ${#files[@]} )) || { notify-send "Wallpaper" "No hay imagenes en $dir"; exit 1; }
    apply "${files[RANDOM % ${#files[@]}]}"
    ;;
  select)
    (( ${#files[@]} )) || { notify-send "Wallpaper" "No hay imagenes en $dir"; exit 1; }
    pkill -x rofi || true
    # Vista previa de cada imagen en rofi (icono = la propia imagen).
    name="$(for f in "${files[@]}"; do printf '%s\0icon\x1f%s\n' "${f##*/}" "$f"; done \
      | rofi -dmenu -i -show-icons -p "Wallpaper")" || exit 0
    apply "$dir/$name"
    ;;
  restore)
    img="$(readlink -f "$state" 2>/dev/null || true)"
    [[ -n "$img" && -f "$img" ]] || img="$default"
    apply "$img" none
    ;;
  *)
    echo "Uso: $0 select|random|restore" >&2
    exit 1
    ;;
esac
