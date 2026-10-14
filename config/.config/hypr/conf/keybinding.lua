local programs = require("conf.programs")

local mainMod = "SUPER"
local scripts = "~/.config/hypr/scripts"

-- Atajo con descripcion: SUPER+H los lista (hyprctl binds).
local function bind(keys, dispatcher, desc, opts)
    opts = opts or {}
    opts.description = desc
    hl.bind(keys, dispatcher, opts)
end

local function key(k)
    return mainMod .. " + " .. k
end

local exec = hl.dsp.exec_cmd

bind(key("H"), exec(scripts .. "/keyhints.sh"), "Ver atajos de teclado")

bind(key("Space"), exec(programs.terminal), "Terminal")
bind(key("E"), exec(programs.fileManager), "Gestor de archivos")
bind(key("B"), exec(programs.browser), "Navegador")

bind(key("SHIFT + CONTROL + Escape"), hl.dsp.exit(), "Salir de Hyprland")
bind(key("Q"), hl.dsp.window.close(), "Cerrar ventana")
bind(key("SHIFT + Q"), hl.dsp.window.kill(), "Matar ventana")

bind(key("P"), hl.dsp.window.pseudo(), "Pseudotile (dwindle)")
bind(key("J"), hl.dsp.layout("togglesplit"), "Alternar split (dwindle)")
bind(key("SHIFT + F"), hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), "Pantalla completa")
bind(key("F"), hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), "Maximizar (mantiene la barra y el dock)")
bind(key("C"), hl.dsp.window.center(), "Centrar ventana flotante")
bind("ALT + Tab", hl.dsp.window.cycle_next(), "Siguiente ventana (mantiene el maximizado)")
bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }), "Ventana anterior (mantiene el maximizado)")
bind(key("T"), hl.dsp.group.toggle(), "Agrupar ventanas en pestañas / desagrupar")
bind(key("SHIFT + T"), hl.dsp.window.move({ out_of_group = true }), "Sacar ventana del grupo de pestañas")
bind(key("ALT + right"), hl.dsp.group.next(), "Pestaña siguiente")
bind(key("ALT + left"), hl.dsp.group.prev(), "Pestaña anterior")
bind(key("Tab"), hl.dsp.focus({ workspace = "previous" }), "Workspace anterior")
bind(key("S"), hl.dsp.workspace.toggle_special("magic"), "Mostrar/ocultar scratchpad")
bind(key("ALT + S"), hl.dsp.window.move({ workspace = "special:magic" }), "Mandar ventana al scratchpad")

for _, d in ipairs({ "left", "right", "up", "down" }) do
    bind(key("SHIFT + " .. d), hl.dsp.window.move({ direction = d }), "Mover ventana")
end
bind(key("CONTROL + left"),  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), "Redimensionar ventana", { repeating = true })
bind(key("CONTROL + right"), hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), "Redimensionar ventana", { repeating = true })
bind(key("CONTROL + up"),    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), "Redimensionar ventana", { repeating = true })
bind(key("CONTROL + down"),  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), "Redimensionar ventana", { repeating = true })

bind(key("L"), exec("hyprlock"), "Bloquear pantalla")
bind(key("Escape"), exec("wlogout -b 5"), "Menu de apagado")
bind(key("R"), exec("rofi -show drun"), "Lanzador de apps")
bind("ALT + Space", exec("rofi -show drun"), "Lanzador de apps")
bind(key("PERIOD"), exec("rofi -show emoji"), "Selector de emojis")
bind(key("V"), exec(scripts .. "/clipboard.sh"), "Historial del portapapeles")
bind(key("W"), exec(scripts .. "/wallpaper.sh select"), "Elegir wallpaper")
bind(key("SHIFT + W"), exec(scripts .. "/wallpaper.sh random"), "Wallpaper aleatorio")
bind(key("N"), exec("swaync-client -t -sw"), "Centro de notificaciones")
bind(key("SHIFT + S"), exec(scripts .. "/screenshot.sh region"), "Captura de region")
bind("Print", exec(scripts .. "/screenshot.sh screen"), "Captura de pantalla completa")
bind(key("SHIFT + E"), exec(scripts .. "/screenshot.sh edit"), "Captura y editar con swappy")

-- Move focus with mainMod + arrow keys
for _, d in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(key(d), hl.dsp.focus({ direction = d }))
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local k = i % 10 -- 10 maps to key 0
    hl.bind(key(k), hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"), hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(key("mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
local media = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), media)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), media)
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), media)
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), media)
hl.bind("XF86MonBrightnessUp", exec("brightnessctl s 10%+"), media)
hl.bind("XF86MonBrightnessDown", exec("brightnessctl s 10%-"), media)

-- Requires playerctl
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })
