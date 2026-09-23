#!/usr/bin/env bash
set -euo pipefail

pkglist="${1:-}"

if [[ -z "$pkglist" || ! -f "$pkglist" ]]; then
  echo "Usage: $0 packages/file.pkglist"
  exit 1
fi

mapfile -t packages < <(grep -vE '^\s*(#|$)' "$pkglist")

if (( ${#packages[@]} == 0 )); then
  echo "No packages found in $pkglist"
  exit 0
fi

if [[ "$(basename "$pkglist")" == "aur.pkglist" ]]; then
  aur_helper=""
  if command -v yay >/dev/null 2>&1; then
    aur_helper=yay
  elif command -v paru >/dev/null 2>&1; then
    aur_helper=paru
  fi

  if [[ -z "$aur_helper" ]]; then
    echo "No hay un AUR helper instalado (yay/paru)." >&2
    echo "Corre primero: ./scripts/install-aur-helper.sh" >&2
    exit 1
  fi

  echo "Installing AUR packages from $pkglist with $aur_helper"
  "$aur_helper" -S --needed "${packages[@]}"
else
  echo "Installing packages from $pkglist"
  sudo pacman -S --needed "${packages[@]}"
fi
