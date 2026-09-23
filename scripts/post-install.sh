#!/usr/bin/env bash
# Ajustes de usuario que no son archivos enlazables (no necesita sudo).
set -euo pipefail

xdg-user-dirs-update

# mimeapps.list no se enlaza con stow: otras apps (ej. Claude Code) escriben ahi.
set_default() {
  local desktop="$1"; shift
  if [[ -f "/usr/share/applications/$desktop" ]]; then
    xdg-mime default "$desktop" "$@"
  else
    echo "Omitido $desktop (no instalado)" >&2
  fi
}

set_default thunar.desktop inode/directory
set_default chromium.desktop x-scheme-handler/http x-scheme-handler/https text/html
set_default imv.desktop image/png image/jpeg image/gif image/webp image/bmp image/svg+xml
set_default mpv.desktop video/mp4 video/x-matroska video/webm video/quicktime audio/mpeg audio/flac audio/ogg audio/wav
set_default org.pwmt.zathura.desktop application/pdf
set_default org.xfce.mousepad.desktop text/plain text/markdown application/x-shellscript application/json

echo "Carpetas de usuario y apps por defecto listas."
