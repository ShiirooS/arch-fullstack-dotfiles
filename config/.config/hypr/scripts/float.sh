#!/usr/bin/env bash
# SUPER+F: alternar flotante. Al pasar a flotante, la ventana queda al 70% del
# area libre y centrada (sin tapar waybar ni el dock). Sin esto conserva el
# tamano de pantalla completa y se sale por arriba.
# Uso: float.sh [address]   (sin argumento: la ventana activa)
set -euo pipefail

addr="${1:-$(hyprctl activewindow -j | jq -r '.address')}"
[[ -n "$addr" && "$addr" != "null" ]] || exit 0

hyprctl dispatch togglefloating "address:$addr" >/dev/null

win="$(hyprctl clients -j | jq -c --arg a "$addr" '.[] | select(.address == $a)')"
[[ "$(jq -r '.floating' <<<"$win")" == "true" ]] || exit 0

# Area libre del monitor de la ventana, en pixeles logicos.
mon="$(hyprctl monitors -j | jq -c --argjson id "$(jq '.monitor' <<<"$win")" '.[] | select(.id == $id)')"
read -r mx my mw mh rl rt rr rb < <(jq -r '
  [.x, .y, (.width / .scale | floor), (.height / .scale | floor)] + .reserved | @tsv' <<<"$mon")
# Hyprland con transform 90/270 intercambia ancho y alto.
if (( $(jq '.transform % 2' <<<"$mon") == 1 )); then read -r mw mh <<<"$mh $mw"; fi

aw=$(( mw - rl - rr )); ah=$(( mh - rt - rb ))
w=$(( aw * 70 / 100 )); h=$(( ah * 70 / 100 ))
x=$(( mx + rl + (aw - w) / 2 )); y=$(( my + rt + (ah - h) / 2 ))

hyprctl --batch "dispatch resizewindowpixel exact $w $h,address:$addr; dispatch movewindowpixel exact $x $y,address:$addr" >/dev/null
