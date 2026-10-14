hl.config({
    animations = {
        enabled = true,
    },
})

-- Sin rebote: con una curva que se pasa del tamano final (overshoot) las apps
-- (Chrome, Electron) no alcanzan a redibujar y se ven estiradas o temblando.
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "easeOutQuint",   style = "popin 90%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2, bezier = "linear",         style = "popin 90%" })
-- Mover/redimensionar ventanas: corto para que el contenido no quede atras.
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "layers",      enabled = true, speed = 3, bezier = "easeOutQuint",   style = "fade" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "border",      enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 4, bezier = "easeInOutCubic", style = "slide" })
