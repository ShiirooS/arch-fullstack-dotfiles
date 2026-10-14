hl.config({
    input = {
        kb_layout = "us",

        follow_mouse = 1,

        sensitivity   = 0, -- -1.0 - 1.0, 0 means no modification.
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.5,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
