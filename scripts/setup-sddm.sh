#!/usr/bin/env bash
# Tema de login: sddm-astronaut-theme (AUR, en aur.pkglist).
# Uso: sudo ./scripts/setup-sddm.sh [variante]   (default: hyprland_kath)
# Variantes: ls /usr/share/sddm/themes/sddm-astronaut-theme/Themes
set -euo pipefail

variant="${1:-hyprland_kath}"
theme_dir="/usr/share/sddm/themes/sddm-astronaut-theme"

if (( EUID != 0 )); then
  echo "Correr con sudo: sudo $0 $variant" >&2
  exit 1
fi

[[ -d "$theme_dir" ]] || { echo "Falta el tema: ./scripts/install-packages.sh packages/aur.pkglist" >&2; exit 1; }
[[ -f "$theme_dir/Themes/$variant.conf" ]] || { echo "No existe la variante $variant" >&2; exit 1; }

install -d /etc/sddm.conf.d
cat > /etc/sddm.conf.d/theme.conf <<'EOF'
[Theme]
Current=sddm-astronaut-theme
EOF

# SDDM lee <ConfigFile>.user y sus valores pisan los del tema. Asi se elige la
# variante sin editar metadata.desktop, que pertenece al paquete y se pisaria
# en cada actualizacion.
install -m644 "$theme_dir/Themes/$variant.conf" "$theme_dir/Themes/astronaut.conf.user"

echo "SDDM: tema sddm-astronaut-theme, variante $variant."
echo "Vista previa sin reiniciar: sddm-greeter-qt6 --test-mode --theme $theme_dir"
