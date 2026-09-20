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

echo "Installing packages from $pkglist"
sudo pacman -S --needed "${packages[@]}"
