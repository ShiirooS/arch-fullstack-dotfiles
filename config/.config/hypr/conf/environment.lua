hl.env("XCURSOR_THEME", "macOS")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "macOS")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
-- Steam corre en Xwayland y con force_zero_scaling se ve diminuto: que escale solo.
-- Tiene que coincidir con la escala del monitor (hyprctl monitors: 1.5 en eDP-1).
hl.env("STEAM_FORCE_DESKTOPUI_SCALING", "1.5")

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    ecosystem = {
        no_update_news = true,
    },
})
