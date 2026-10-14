-- Externa (HDMI) a la izquierda, portatil a la derecha.
-- eDP-1 empieza en x=1920 porque la externa mide 1920 px logicos (escala 1).
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0",    scale = 1 })
hl.monitor({ output = "eDP-1",    mode = "preferred", position = "1920x0", scale = 1.5 })

-- Cualquier otra pantalla que se conecte
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
