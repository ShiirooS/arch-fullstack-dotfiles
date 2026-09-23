#!/usr/bin/env bash
# Uso: wallpaper.sh select | random | restore
set -euo pipefail

dir="$HOME/dotfiles/wallpapers"
default="$dir/misty-seascape.jpg"
# Symlink a la eleccion actual: lo lee restore al iniciar sesion y lo usa hyprlock.
state="$HOME/.local/state/hypr/current-wallpaper"

apply() {
  local img="$1" mon
  mkdir -p "${state%/*}"
  ln -sfn "$img" "$state"
  for mon in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$mon,$img,cover" >/dev/null
  done
}

mapfile -t files < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)

case "${1:-select}" in
  random)
    (( ${#files[@]} )) || { notify-send "Wallpaper" "No hay imagenes en $dir"; exit 1; }
    apply "${files[RANDOM % ${#files[@]}]}"
    ;;
  select)
    (( ${#files[@]} )) || { notify-send "Wallpaper" "No hay imagenes en $dir"; exit 1; }
    name="$(printf '%s\n' "${files[@]##*/}" | rofi -dmenu -i -p "Wallpaper")" || exit 0
    apply "$dir/$name"
    ;;
  restore)
    img="$(readlink -f "$state" 2>/dev/null || true)"
    [[ -n "$img" && -f "$img" ]] || img="$default"
    # hyprpaper arranca en paralelo: esperar a que su IPC responda.
    for _ in $(seq 1 20); do
      hyprctl hyprpaper listactive >/dev/null 2>&1 && break
      sleep 0.5
    done
    apply "$img"
    ;;
  *)
    echo "Uso: $0 select|random|restore" >&2
    exit 1
    ;;
esac
