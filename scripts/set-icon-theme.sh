#!/usr/bin/env bash
# Cambia el tema de iconos en todos los archivos del repo y lo aplica ya.
# Uso: set-icon-theme.sh WhiteSur-dark | Papirus-Dark | <otro tema instalado>
set -euo pipefail

theme="${1:-}"
if [[ -z "$theme" ]]; then
  echo "Uso: $0 <tema>   (ej. WhiteSur-dark, Papirus-Dark)" >&2
  exit 1
fi
if [[ ! -d "/usr/share/icons/$theme" && ! -d "$HOME/.local/share/icons/$theme" ]]; then
  echo "El tema '$theme' no esta instalado." >&2
  exit 1
fi

cfg="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/config/.config"

sed -i "s/^gtk-icon-theme-name=.*/gtk-icon-theme-name=$theme/" \
  "$cfg/gtk-3.0/settings.ini" "$cfg/gtk-4.0/settings.ini"
sed -i "s/^icon_theme=.*/icon_theme=$theme/" "$cfg/qt6ct/qt6ct.conf"
sed -i "s/icon-theme' '[^']*'/icon-theme' '$theme'/" "$cfg/hypr/scripts/gtk-theme.sh"

# Aplicar en la sesion actual (si hay una).
if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  gsettings set org.gnome.desktop.interface icon-theme "$theme"
  if pgrep -x nwg-dock-hyprla >/dev/null; then
    pkill -x nwg-dock-hyprla || true
    hyprctl dispatch exec ~/.config/hypr/scripts/dock.sh >/dev/null
  fi
fi

echo "Iconos: $theme. Las apps ya abiertas lo toman al reabrirlas."
