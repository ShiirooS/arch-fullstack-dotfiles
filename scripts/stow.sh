#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

packages=(config shell tmux git nvim)

for package in "${packages[@]}"; do
  echo "Stowing $package"
  stow --target="$HOME" --restow "$package"
done
