#!/usr/bin/env bash
# Muestra los binds con comentario "# descripcion" de keybinding.conf.
set -euo pipefail

conf="$HOME/.config/hypr/conf/keybinding.conf"

grep -E '^bind[a-z]* *=.*#' "$conf" \
  | sed -E 's/^bind[a-z]* *= *//; s/\$mainMod/SUPER/g' \
  | awk -F'#' '{
      split($1, p, ",");
      gsub(/^ +| +$/, "", p[1]); gsub(/^ +| +$/, "", p[2]); gsub(/^ +| +$/, "", $2);
      key = (p[1] == "" ? p[2] : p[1] " + " p[2]);
      printf "%-28s %s\n", key, $2
    }' \
  | rofi -dmenu -i -p "Keybinds" >/dev/null || true
