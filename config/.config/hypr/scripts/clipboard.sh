#!/usr/bin/env bash
set -euo pipefail

selection="$(cliphist list | rofi -dmenu -i -p "Clipboard")" || exit 0
printf '%s' "$selection" | cliphist decode | wl-copy
