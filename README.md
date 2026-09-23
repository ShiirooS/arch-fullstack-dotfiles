# Arch Fullstack Dotfiles

Configuracion personal para Arch Linux + Hyprland orientada a desarrollo fullstack.

Esta base toma ideas del flujo de ViegPhunt, pero esta organizada para ser:

- reproducible con GNU Stow;
- facil de auditar antes de instalar;
- modular por herramienta;
- liviana para equipos con 8 GB de RAM;
- pensada para desarrollo web, Node.js, Python, Docker y Neovim.

## Referencias analizadas

- ViegPhunt/Arch-Hyprland: instalador de sistema para Hyprland.
- ViegPhunt/Dotfiles: configuraciones de Hyprland, Waybar, Ghostty, Rofi, Zsh, Tmux y Neovim usando Stow.

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

## Estructura

```text
.
├── packages/
│   ├── base.pkglist
│   ├── desktop-hyprland.pkglist
│   ├── dev-fullstack.pkglist
│   ├── aur.pkglist
│   └── optional.pkglist
├── scripts/
│   ├── bootstrap.sh
│   ├── install-packages.sh
│   ├── install-aur-helper.sh
│   └── stow.sh
├── config/
│   └── .config/
│       ├── colors/        # paleta Catppuccin compartida (css/rasi)
│       ├── ghostty/
│       ├── gtk-3.0/ gtk-4.0/ qt6ct/ Kvantum/   # tema oscuro GTK/Qt
│       ├── hypr/          # hyprland, hyprlock, hypridle, hyprpaper, scripts/
│       ├── rofi/
│       ├── swaync/
│       ├── waybar/
│       └── wlogout/
├── claude/
│   └── .config/ohmyposh/claude.toml   # statusline de Claude Code
├── wallpapers/
├── shell/
│   └── .zshrc
├── tmux/
│   └── .tmux.conf
├── git/
│   └── .gitconfig
└── nvim/
    └── .config/nvim/init.lua
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

`packages/aur.pkglist` contiene paquetes que no estan en pacman oficial (por ejemplo
`wlogout`, `oh-my-posh-bin`). `install-aur-helper.sh` instala `yay` desde AUR (build con
`makepkg`, sin `curl | bash`) si no hay ya un helper (`yay`/`paru`) presente; luego
`install-packages.sh` detecta que el pkglist es `aur.pkglist` y usa ese helper en vez
de `pacman` directo.

## Notas para 8 GB RAM

- Usa Hyprland, no un escritorio completo pesado.
- Evita iniciar Docker automaticamente si no lo usas todos los dias.
- Usa `earlyoom` para evitar bloqueos por memoria.
- Mantiene animaciones razonables y pocos servicios residentes.
- Neovim queda minimalista al inicio; los plugins grandes pueden agregarse luego.
