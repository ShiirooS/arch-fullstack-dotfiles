# Instalacion paso a paso

Todos los comandos, en orden, para dejar el sistema igual que el repo. Los que
llevan `sudo` piden contrasena y hay que correrlos en una terminal real.

## 1. Clonar el repo

```bash
git clone https://github.com/ShiirooS/arch-fullstack-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

El repo asume que vive en `~/dotfiles` (los wallpapers se referencian desde ahi).

## 2. Paquetes

```bash
./scripts/bootstrap.sh --dry-run   # ver que va a hacer
./scripts/bootstrap.sh             # hace todo lo de abajo en orden
```

O por partes:

```bash
sudo pacman -Syu
./scripts/install-packages.sh packages/base.pkglist
./scripts/install-packages.sh packages/desktop-hyprland.pkglist
./scripts/install-aur-helper.sh                     # instala yay si no hay helper
./scripts/install-packages.sh packages/aur.pkglist  # wlogout, oh-my-posh, sddm-astronaut, cursor/iconos macOS, fzf-tab, tpm, pokemon
./scripts/install-packages.sh packages/dev-fullstack.pkglist
```

`yay` hace preguntas (limpiar build, ver diffs): correrlo solo, no pegado junto con
otros comandos, o las lineas siguientes se toman como respuestas.

`packages/optional.pkglist` no se instala solo: apps a eleccion (VS Code, Postman,
DBeaver, MongoDB Compass, Chrome, Obsidian, OnlyOffice, Discord, Spotify, Steam,
Minecraft). Steam necesita el repo de 32 bits `[multilib]`:

```bash
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo sed -i '/^#\[multilib\]$/{s/^#//;n;s/^#Include/Include/}' /etc/pacman.conf
sudo pacman -Syu
yay -S --needed $(grep -vE '^\s*(#|$)' packages/optional.pkglist)
```

Chrome y VS Code leen `~/.config/chrome-flags.conf` / `code-flags.conf` (Wayland y
llavero). Spotify corre nativo en Wayland por `~/.config/spotify-launcher.conf`. Steam escala con `STEAM_FORCE_DESKTOPUI_SCALING` en `hypr/conf/environment.conf`.

## 3. Enlazar dotfiles

```bash
./scripts/stow.sh
```

- Enlaza los paquetes `config shell tmux git nvim claude` en `$HOME`.
- Si un archivo real ya ocupa el lugar de un link, lo mueve a `<archivo>.bak-<fecha>` antes de enlazar.
- Si Hyprland genero un `~/.config/hypr/hyprland.lua` por defecto, tambien lo respalda. Hyprland >= 0.55 prefiere `hyprland.lua` sobre `hyprland.conf`, asi que ese archivo tapaba toda la config del repo.

Verificar la config de Hyprland sin arrancarlo:

```bash
Hyprland --verify-config -c ~/.config/hypr/hyprland.conf
```

Carpetas de usuario (`~/Pictures`, `~/Documents`, ...), apps por defecto
(thunar, chromium, imv, mpv, zathura, mousepad), cache de fuentes, apps fijadas
en el dock y plugins de tmux:

```bash
./scripts/post-install.sh
```

## Pantalla de login (SDDM)

Tema `sddm-astronaut-theme` (AUR, viene en `aur.pkglist`) con la variante animada
`hyprland_kath`:

```bash
sudo ./scripts/setup-sddm.sh                 # o: sudo ./scripts/setup-sddm.sh pixel_sakura
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/sddm-astronaut-theme   # vista previa
```

La variante se elige con `Themes/astronaut.conf.user` (SDDM lo superpone al tema),
asi no se edita `metadata.desktop`, que el paquete pisa en cada actualizacion.

Neovim instala sus plugins solo la primera vez que se abre (lazy.nvim), y despues
los servidores LSP y formateadores con mason. Para hacerlo sin abrirlo:

```bash
nvim --headless "+Lazy! sync" +qa
# mason-lspconfig no instala servidores en modo headless: hacerlo a mano
nvim --headless -c "MasonInstall lua-language-server pyright typescript-language-server html-lsp css-lsp json-lsp bash-language-server dockerfile-language-server" -c qa
```

## Estilo macOS

- Cursor `macOS` (`apple_cursor`) en Hyprland, GTK, Qt y SDDM.
- Iconos `WhiteSur-dark` (`whitesur-icon-theme`). Papirus sigue instalado; para volver:

  ```bash
  ./scripts/set-icon-theme.sh Papirus-Dark      # o WhiteSur-dark
  ```

- Fuente de interfaz Inter (parecida a San Francisco), codigo en JetBrainsMono Nerd
  Font (`config/.config/fontconfig/fonts.conf`).
- Dock abajo (`nwg-dock-hyprland`, `hypr/scripts/dock.sh`): apps fijadas y abiertas,
  boton lanzador que abre rofi. Click derecho en un icono para fijar/desfijar. Para
  que se oculte solo, cambiar `-x` por `-d` en `dock.sh`.
- Wallpaper con `awww`: transicion animada al cambiarlo (`SUPER + W`).

## 4. Servicios y sistema

```bash
sudo systemctl enable --now NetworkManager bluetooth earlyoom
sudo systemctl enable --now power-profiles-daemon   # perfiles de energia (powerprofilesctl)
sudo systemctl enable --now paccache.timer          # limpia la cache de pacman (deja 3 versiones)
systemctl --user enable --now batsignal              # aviso de bateria baja
sudo systemctl enable docker.socket        # docker arranca recien al usarlo
sudo systemctl enable sddm                 # login grafico
sudo timedatectl set-timezone <Region/Ciudad>   # ej. America/Panama
chsh -s /usr/bin/zsh                       # shell por defecto (aplica al re-loguear)
```

- La zona horaria importa: el reloj de waybar y las horas de reinicio de la barra de
  Claude Code se muestran en hora local.
- Docker por socket en vez de `docker.service`: no ocupa RAM hasta el primer
  `docker ...`. Si ya estaba el servicio: `sudo systemctl disable --now docker.service`.
- `shell/.zshenv` agrega `~/.local/bin` al PATH (ahi vive `claude`); sin eso,
  al pasar a zsh el comando `claude` no se encuentra.

## 5. Claude Code: barra de estado con oh-my-posh

El tema vive en el repo (`claude/.config/ohmyposh/claude.toml`, enlazado por
`stow.sh`). `~/.claude/settings.json` no se enlaza porque Claude Code lo reescribe;
agregar a mano:

```json
"statusLine": {
  "type": "command",
  "command": "oh-my-posh claude --config ~/.config/ohmyposh/claude.toml",
  "padding": 0
}
```

Muestra: modelo, contexto usado (gauge, % y tokens libres), limite de 5 horas
(% usado y hora de reinicio), limite semanal (% usado y dia/hora de reinicio) y un
gatito al final. Los limites vienen como porcentaje del plan, no en tokens.

Probar el tema sin reiniciar Claude Code:

```bash
echo '{"model":{"display_name":"Test"},"context_window":{"context_window_size":200000,"used_percentage":10}}' \
  | oh-my-posh claude --config ~/.config/ohmyposh/claude.toml
```

## 6. Despues del primer login

Cerrar sesion y volver a entrar (SDDM, sesion "Hyprland"). Deberia verse:

- wallpaper (`awww`), waybar arriba, dock abajo, notificaciones (swaync), applet de red;
- tema oscuro en apps GTK y Qt, iconos WhiteSur, cursor macOS;
- bloqueo automatico a los 5 min (`hypridle`).

Chequeos rapidos:

```bash
awww query                                        # wallpaper activo
pgrep -a 'waybar|swaync|hypridle|awww-daemon|nwg-dock|polkit-gnome'
notify-send "Prueba" "notificaciones OK"
```

## Atajos de teclado

Salen de `config/.config/hypr/conf/keybinding.conf` (`SUPER + H` los muestra en rofi).

| Atajo | Accion |
| --- | --- |
| `SUPER + H` | Ver atajos de teclado |
| `SUPER + Space` | Terminal (ghostty) |
| `SUPER + E` | Gestor de archivos (thunar) |
| `SUPER + B` | Navegador (chromium) |
| `SUPER + R` / `Alt + Space` | Lanzador de apps (rofi) |
| `SUPER + .` | Selector de emojis |
| `SUPER + V` | Historial del portapapeles |
| `SUPER + W` | Elegir wallpaper |
| `SUPER + Shift + W` | Wallpaper aleatorio |
| `SUPER + N` | Centro de notificaciones |
| `SUPER + L` | Bloquear pantalla |
| `SUPER + Escape` | Menu de apagado (wlogout) |
| `SUPER + Shift + S` | Captura de region |
| `Print` | Captura de pantalla completa |
| `SUPER + Shift + E` | Captura y editar con swappy |
| `SUPER + Q` | Cerrar ventana |
| `SUPER + Shift + Q` | Matar ventana |
| `SUPER + P` | Pseudotile |
| `SUPER + J` | Alternar split |
| `SUPER + Shift + F` | Pantalla completa |
| `SUPER + F` | Maximizar (mantiene la barra y el dock) |
| `SUPER + C` | Centrar ventana flotante |
| `SUPER + Tab` | Workspace anterior |
| `SUPER + S` | Mostrar/ocultar scratchpad |
| `SUPER + Alt + S` | Mandar ventana al scratchpad |
| `SUPER + Shift + flechas` | Mover ventana |
| `SUPER + Control + flechas` | Redimensionar ventana |
| `SUPER + 1..0` | Ir al workspace 1..10 |
| `SUPER + Shift + 1..0` | Mover ventana al workspace 1..10 |
| `SUPER + flechas` | Mover foco |
| `SUPER + click izq/der` | Mover / redimensionar ventana |
| `SUPER + Shift + Control + Escape` | Salir de Hyprland |

Las capturas se guardan en `~/Pictures/Screenshots`.

Barra superior (waybar): workspaces a la izquierda y estado del sistema a la
derecha. Las ventanas abiertas se ven en el dock de abajo. El contador `󰚰 N` muestra
actualizaciones pendientes (oficiales + AUR, se revisa cada hora) y con un click
abre `yay -Syu` en una terminal.

## Terminal

- zsh con el prompt de ViegPhunt (oh-my-posh, `shell/.config/ohmyposh/viet.omp.json`),
  autocompletado con vista previa (`fzf-tab`), sugerencias y resaltado. Un pokemon
  al abrir la terminal (`pokemon-colorscripts`).
- tmux: prefijo `Ctrl + Z`. `prefijo + H` / `V` dividir, `N` ventana nueva (en la
  carpeta actual), `W` / `S` renombrar ventana/sesion, `Q` cerrar ventana, `r`
  recargar, `I` instalar plugins.
- Neovim (config de ViegPhunt adaptada a fullstack): `Space e` arbol de archivos,
  `Space ff` / `Space fg` buscar archivos / texto, `Space gf` formatear,
  `` Space ` `` terminal, `Space /` comentar, `K` documentacion, `Space w` guardar.
- Extras: `cava` (visualizador de audio), `btop`, `lazydocker` (`lzd`), `lazygit` (`lg`).

## Notas de mantenimiento

- TPM: con systemd 262 cuatro servicios de medicion (NvPCR) fallan en cada arranque
  porque el TPM de la laptop no tiene ese indice. El disco no esta cifrado y nada usa
  esas medidas, asi que se desactivan:
  `sudo systemctl mask systemd-pcrproduct.service systemd-pcrlogin@.service systemd-tpm2-setup-early.service && sudo systemctl reset-failed`.
  Si algun dia se cifra el disco con TPM (`systemd-cryptenroll`), revertir con `unmask`.
- Ventanas chicas (volumen, bluetooth, red, dialogos de archivos, picture-in-picture)
  abren flotantes y centradas: `hypr/conf/windowrule.conf`.

- `config/.config/pacman/makepkg.conf` desactiva `debug` para builds de AUR (yay
  deja de instalar paquetes `*-debug`).
- git: identidad global en `git/.gitconfig` (email noreply de GitHub). Para repos de
  trabajo: `git config user.email <otro>` dentro de ese repo.
- Firmware: `fwupdmgr refresh && fwupdmgr get-updates` para ver actualizaciones de
  BIOS/firmware; aplicarlas con `fwupdmgr update` (a mano, conectado a corriente).
- Llavero: `gnome-keyring` se desbloquea solo al entrar por SDDM (PAM). Chromium lo
  usa por `config/.config/chromium-flags.conf` (`--password-store=gnome-libsecret`).
  Para mover el token de `gh` del archivo en texto plano al llavero:
  `gh auth login --with-token <<< "$(gh auth token)"`.
