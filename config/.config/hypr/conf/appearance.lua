hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 5,

        border_size = 2,

        col = {
            active_border   = "rgba(cdd6f4aa)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 2,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
        },
    },

    -- Grupos de ventanas (pestañas): mismos colores que los bordes
    group = {
        col = {
            border_active   = "rgba(cdd6f4aa)",
            border_inactive = "rgba(595959aa)",
        },

        groupbar = {
            font_size           = 11,
            height              = 18,
            gradients           = true,
            rounding            = 2,
            col = {
                active   = "rgba(cdd6f4aa)",
                inactive = "rgba(313244aa)",
            },
            text_color          = "rgba(11111bff)",
            text_color_inactive = "rgba(cdd6f4ff)",
        },
    },
})

-- Blur waybar
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
-- Blur wlogout
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })

-- Dock (nwg-dock-hyprland): fondo translucido con blur, estilo macOS
hl.layer_rule({ match = { namespace = "nwg-dock.*" }, blur = true, ignore_alpha = 0.3 })
-- Blur swaync
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })
