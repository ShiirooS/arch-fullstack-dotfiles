#!/usr/bin/env bash
# Uso: wallpaper.sh select | random
set -euo pipefail

dir="$HOME/dotfiles/wallpapers"
mapfile -t files < <(find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)

(( ${#files[@]} )) || { notify-send "Wallpaper" "No hay imagenes en $dir"; exit 1; }

case "${1:-select}" in
  random)
    choice="${files[RANDOM % ${#files[@]}]}"
    ;;
  select)
    name="$(printf '%s\n' "${files[@]##*/}" | rofi -dmenu -i -p "Wallpaper")" || exit 0
    choice="$dir/$name"
    ;;
  *)
    echo "Uso: $0 select|random" >&2
    exit 1
    ;;
esac

hyprctl monitors -j | jq -r '.[].name' | while read -r mon; do
  hyprctl hyprpaper wallpaper "$mon,$choice,cover" >/dev/null
done
