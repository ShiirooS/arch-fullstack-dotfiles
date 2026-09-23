#!/usr/bin/env bash
set -euo pipefail

if command -v yay >/dev/null 2>&1 || command -v paru >/dev/null 2>&1; then
  echo "AUR helper ya instalado, nada que hacer."
  exit 0
fi

echo "Instalando yay (AUR helper) desde AUR..."
sudo pacman -S --needed --noconfirm base-devel git

build_dir="$(mktemp -d)"
trap 'rm -rf "$build_dir"' EXIT

git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$build_dir/yay-bin"
(cd "$build_dir/yay-bin" && makepkg -si --noconfirm)

echo "yay instalado."
