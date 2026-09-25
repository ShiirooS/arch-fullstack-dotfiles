#!/usr/bin/env bash
# Las apps GTK4/libadwaita ignoran settings.ini: leen el esquema de gsettings.
# El tema de iconos se cambia con ~/dotfiles/scripts/set-icon-theme.sh.
set -euo pipefail

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'macOS'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
