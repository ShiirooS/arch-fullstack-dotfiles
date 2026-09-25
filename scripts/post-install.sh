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

# Fuentes nuevas (inter-font) y config de fontconfig enlazada por stow.
fc-cache -f >/dev/null

# Apps fijadas en el dock. El dock reescribe este archivo al fijar/desfijar,
# por eso no se enlaza: solo se crea si no existe.
pinned="${XDG_CACHE_HOME:-$HOME/.cache}/nwg-dock-pinned"
if [[ ! -e "$pinned" ]]; then
  mkdir -p "${pinned%/*}"
  printf '%s\n' com.mitchellh.ghostty thunar chromium nvim > "$pinned"
fi

# Plugins de tmux (tpm de AUR). Arranca un servidor temporal si no hay uno.
tpm=/usr/share/tmux-plugin-manager
if [[ -x "$tpm/bin/install_plugins" ]]; then
  if tmux has-session 2>/dev/null; then
    tmux source-file ~/.tmux.conf
    "$tpm/bin/install_plugins"
  else
    tmux new-session -d -s tpm-setup
    "$tpm/bin/install_plugins"
    tmux kill-session -t tpm-setup
  fi
else
  echo "Omitidos plugins de tmux (falta tmux-plugin-manager)" >&2
fi

echo "Carpetas de usuario, apps por defecto, fuentes, dock y tmux listos."
