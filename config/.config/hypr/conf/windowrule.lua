hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    -- Disable blur for floating XWayland window
    name  = "no-blur-xwayland-float",
    match = { xwayland = true, float = true },

    no_blur = true,
})

hl.window_rule({
    name  = "small-utilities-float",
    match = { class = "^(org.pulseaudio.pavucontrol|pavucontrol|blueman-manager|\\.?blueman-manager-wrapped|nm-connection-editor|nwg-look|qt6ct|kvantummanager)$" },

    float  = true,
    size   = "800 520",
    center = true,
})

hl.window_rule({
    name  = "file-dialogs-float",
    match = { title = "^(Open File|Save File|Open Folder|Select a File|Guardar archivo|Abrir archivo).*$" },

    float  = true,
    size   = "900 560",
    center = true,
})

hl.window_rule({
    name  = "pip",
    match = { title = "^(Picture.in.picture)$" },

    float = true,
    pin   = true,
    size  = "480 270",
    move  = "(monitor_w-500) (monitor_h-360)",
})
