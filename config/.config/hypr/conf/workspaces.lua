-- 1-5 en el portatil, 6-10 en la externa.
-- Si la externa no esta conectada, Hyprland deja 6-10 en el portatil.
for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = i <= 5 and "eDP-1" or "HDMI-A-1",
        default   = (i == 1 or i == 6),
    })
end
