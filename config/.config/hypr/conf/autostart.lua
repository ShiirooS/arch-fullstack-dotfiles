local scripts = "~/.config/hypr/scripts"

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(scripts .. "/wallpaper.sh restore")
    hl.exec_cmd(scripts .. "/dock.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd(scripts .. "/gtk-theme.sh")
    hl.exec_cmd("hyprctl setcursor macOS 24")
end)

-- awww no pinta pantallas conectadas despues de arrancar (quedan en negro):
-- reaplicar el wallpaper actual cada vez que se conecta un monitor.
hl.on("monitor.added", function()
    hl.exec_cmd(scripts .. "/wallpaper.sh restore")
end)
