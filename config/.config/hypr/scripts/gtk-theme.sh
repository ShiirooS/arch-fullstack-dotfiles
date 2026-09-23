#!/usr/bin/env bash
# Las apps GTK4/libadwaita ignoran settings.ini: leen el esquema de gsettings.
set -euo pipefail

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 11'
