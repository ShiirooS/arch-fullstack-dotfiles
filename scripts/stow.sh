#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

packages=(config shell tmux git nvim claude)
stamp="$(date +%Y%m%d-%H%M%S)"

# Hyprland >= 0.55 prefiere hyprland.lua sobre hyprland.conf: si genero uno
# por defecto en el primer arranque, taparia la config del repo.
lua_cfg="$HOME/.config/hypr/hyprland.lua"
if [[ -f "$lua_cfg" && ! -L "$lua_cfg" ]]; then
  echo "Respaldando $lua_cfg -> $lua_cfg.bak-$stamp"
  mv "$lua_cfg" "$lua_cfg.bak-$stamp"
fi

for package in "${packages[@]}"; do
  [[ -d "$package" ]] || continue

  # Archivos reales que chocan con un link de stow: se mueven a .bak-<fecha>.
  mapfile -t conflicts < <(
    stow --no --verbose=1 --target="$HOME" --restow "$package" 2>&1 \
      | sed -nE 's/.*over existing target (.+) since.*/\1/p; s/.*existing target is (neither a link nor a directory|not owned by stow): (.+)$/\2/p'
  )
  for rel in "${conflicts[@]}"; do
    target="$HOME/$rel"
    echo "Respaldando $target -> $target.bak-$stamp"
    mv "$target" "$target.bak-$stamp"
  done

  echo "Stowing $package"
  stow --target="$HOME" --restow "$package"
done
