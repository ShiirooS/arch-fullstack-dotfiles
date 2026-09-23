#!/usr/bin/env bash
# Uso: screenshot.sh region | screen | edit
set -euo pipefail

dir="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")/Screenshots"
mkdir -p "$dir"

case "${1:-region}" in
  region) hyprshot -m region -o "$dir" ;;
  screen) hyprshot -m output -o "$dir" ;;
  edit)   geom="$(slurp)" || exit 0; grim -g "$geom" - | swappy -f - ;;
  *)      echo "Uso: $0 region|screen|edit" >&2; exit 1 ;;
esac
