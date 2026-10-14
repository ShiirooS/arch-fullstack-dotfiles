hl.config({
    misc = {
        force_default_wallpaper        = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo          = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering       = true,
        initial_workspace_tracking     = 1,
        on_focus_under_fullscreen      = 1,    -- Al cambiar de ventana, la nueva hereda el maximizado
        exit_window_retains_fullscreen = true, -- Al cerrar la maximizada, la siguiente sigue maximizada
    },

    binds = {
        movefocus_cycles_fullscreen = true, -- SUPER+flechas recorre las ventanas sin salir del maximizado
        movefocus_cycles_groupfirst = true, -- En un grupo (pestañas), SUPER+flechas pasa primero por sus pestañas
    },
})
