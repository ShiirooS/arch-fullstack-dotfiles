#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=true
fi

steps=(
  "sudo pacman -Syu"
  "$repo_root/scripts/install-packages.sh $repo_root/packages/base.pkglist"
  "$repo_root/scripts/install-packages.sh $repo_root/packages/desktop-hyprland.pkglist"
  "$repo_root/scripts/install-aur-helper.sh"
  "$repo_root/scripts/install-packages.sh $repo_root/packages/aur.pkglist"
  "sudo $repo_root/scripts/setup-sddm.sh"
  "$repo_root/scripts/install-packages.sh $repo_root/packages/dev-fullstack.pkglist"
  "$repo_root/scripts/stow.sh"
  "$repo_root/scripts/post-install.sh"
  "sudo systemctl enable --now NetworkManager"
  "sudo systemctl enable --now bluetooth"
  "sudo systemctl enable --now earlyoom"
  "sudo systemctl enable docker.socket"
  "sudo systemctl enable sddm"
  "chsh -s /usr/bin/zsh"
)

echo "Arch Fullstack Dotfiles bootstrap"
echo

for step in "${steps[@]}"; do
  if $dry_run; then
    echo "[dry-run] $step"
  else
    echo "[run] $step"
    eval "$step"
  fi
done

if ! $dry_run; then
  echo
  echo "Done. Reboot before starting a Hyprland session."
fi
