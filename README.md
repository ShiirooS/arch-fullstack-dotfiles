# Arch Fullstack Dotfiles

Configuracion personal para Arch Linux + Hyprland orientada a desarrollo fullstack.

Esta base toma ideas del flujo de ViegPhunt, pero esta organizada para ser:

- reproducible con GNU Stow;
- facil de auditar antes de instalar;
- modular por herramienta;
- liviana para equipos con 8 GB de RAM;
- pensada para desarrollo web, Node.js, Python, Docker y Neovim.

## Referencias analizadas

- ViegPhunt/Arch-Hyprland: instalador de sistema para Hyprland (y su script de
  terminal, ViegPhunt/auto-setup-LT).
- ViegPhunt/Dotfiles: configuraciones de Hyprland, Waybar, Ghostty, Rofi, Zsh, Tmux y Neovim usando Stow.
- ViegPhunt/Wallpaper-Collection: los 8 wallpapers de `wallpapers/`.

## Que se reutiliza como idea

- Separar instalacion del sistema y dotfiles.
- Usar `stow -t "$HOME"` para enlazar configuraciones.
- Mantener `hyprland.conf` como archivo principal que importa modulos.
- Usar Waybar, Rofi, Ghostty, SwayNC, Wlogout y wallpapers dinamicos.
- Usar shell moderno con autocompletado, fuzzy finding y prompt visual.

## Que se cambia

- Scripts con modo `--dry-run` antes de tocar el sistema.
- Paquetes separados por capas.
- Menos adornos pesados por defecto.
- Nada de instalaciones remotas via `curl | bash`.
- Configuracion orientada a fullstack: Node.js, pnpm, Python, Docker, PostgreSQL client, Redis client, Git, Lazygit y Neovim.

## Que incluye

- Hyprland 0.56 (config legacy `hyprland.conf` modular), hyprlock, hypridle, awww.
- Waybar con workspaces, actualizaciones, perfil de energia, bateria, audio y reloj.
- Estilo macOS: dock (nwg-dock-hyprland), cursor macOS, iconos WhiteSur, fuente Inter.
- Rofi (apps, emojis, portapapeles, wallpapers, atajos), SwayNC, Wlogout.
- Login SDDM con `sddm-astronaut-theme` (variante animada `hyprland_kath`).
- Tema oscuro Catppuccin en todo: GTK3 (adw-gtk3-dark), GTK4, Qt (qt6ct + Kvantum).
- zsh + prompt oh-my-posh de ViegPhunt + fzf-tab + zoxide + direnv + autosuggestions + syntax highlighting.
- tmux (Catppuccin, prefijo Ctrl+Z) y Neovim con LSP, telescope, neo-tree y autocompletado.
- Statusline de Claude Code con oh-my-posh (contexto, limites de 5h y semanal).
- Mantenimiento: paccache, power-profiles-daemon, batsignal, gnome-keyring, fwupd.

## Estructura

```text
.
├── INSTALL.md             # todos los comandos en orden + tabla de atajos
├── packages/              # base, desktop-hyprland, dev-fullstack, aur, optional
├── scripts/
│   ├── bootstrap.sh       # todo el flujo (--dry-run)
│   ├── install-packages.sh
│   ├── install-aur-helper.sh
│   ├── stow.sh            # respalda conflictos en .bak-<fecha> y enlaza
│   ├── post-install.sh    # carpetas xdg, apps por defecto, dock, plugins tmux
│   ├── set-icon-theme.sh  # WhiteSur-dark <-> Papirus-Dark
│   └── setup-sddm.sh      # tema de login (sudo)
├── config/
│   ├── .config/
│   │   ├── colors/        # paleta Catppuccin compartida (css/rasi)
│   │   ├── hypr/          # hyprland, hyprlock, hypridle, scripts/ (wallpaper, dock...)
│   │   ├── waybar/ rofi/ swaync/ wlogout/ ghostty/ nwg-dock-hyprland/ cava/
│   │   ├── fontconfig/    # Inter para interfaz, JetBrainsMono para codigo
│   │   ├── gtk-3.0/ gtk-4.0/ qt6ct/ Kvantum/
│   │   ├── pacman/makepkg.conf     # builds de AUR sin paquetes -debug
│   │   ├── xfce4/helpers.rc        # thunar abre ghostty
│   │   └── chromium-flags.conf     # Wayland nativo + llavero
│   ├── .icons/default/    # cursor macOS por defecto
│   └── .local/share/xfce4/helpers/
├── claude/.config/ohmyposh/claude.toml   # statusline de Claude Code
├── wallpapers/
├── shell/ (.zshrc, .zshenv, prompt oh-my-posh)   tmux/   git/   nvim/
```

## Instalacion propuesta

La guia completa, con todos los comandos y la tabla de atajos, esta en
[INSTALL.md](INSTALL.md). Resumen, desde el directorio del repo:

```bash
./scripts/bootstrap.sh --dry-run
./scripts/bootstrap.sh
```

O por partes:

```bash
./scripts/install-packages.sh packages/base.pkglist
./scripts/install-packages.sh packages/desktop-hyprland.pkglist
./scripts/install-aur-helper.sh
./scripts/install-packages.sh packages/aur.pkglist
./scripts/install-packages.sh packages/dev-fullstack.pkglist
./scripts/stow.sh
```

`packages/aur.pkglist` contiene paquetes que no estan en pacman oficial (`wlogout`,
`oh-my-posh-bin`, `sddm-astronaut-theme`, cursor e iconos macOS, `fzf-tab`, tpm y
`pokemon-colorscripts-git`). `install-aur-helper.sh` instala `yay` desde AUR (build con
`makepkg`, sin `curl | bash`) si no hay ya un helper (`yay`/`paru`) presente; luego
`install-packages.sh` detecta que el pkglist es `aur.pkglist` y usa ese helper en vez
de `pacman` directo.

## Notas para 8 GB RAM

- Usa Hyprland, no un escritorio completo pesado.
- Docker arranca por socket: no ocupa RAM hasta el primer `docker ...`.
- Usa `earlyoom` para evitar bloqueos por memoria.
- Mantiene animaciones razonables y pocos servicios residentes.
- Neovim queda minimalista al inicio; los plugins grandes pueden agregarse luego.
