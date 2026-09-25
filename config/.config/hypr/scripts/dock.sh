#!/usr/bin/env bash
# Dock estilo macOS (nwg-dock-hyprland) abajo, siempre visible.
#   -x   reserva su espacio: las ventanas no quedan debajo del dock
#   -i   tamano de iconos   -mb  margen inferior
#   -c   boton lanzador (abre rofi)
# Para que se oculte solo y aparezca al llevar el mouse abajo: cambiar -x por -d.
exec nwg-dock-hyprland -x -i 36 -mb 6 -hd 0 \
  -c "rofi -show drun" -ico view-app-grid-symbolic
