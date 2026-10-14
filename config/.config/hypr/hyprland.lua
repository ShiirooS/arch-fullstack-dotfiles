-- ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗
-- ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
-- ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
-- ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
-- ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
-- ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝
-- -------------------------------------------------------------------
-- Config en Lua (Hyprland >= 0.56; el formato .conf se elimina en 0.57).
-- Hyprland usa este archivo si existe; si no, cae a hyprland.conf.
-- Verificar sin reiniciar: Hyprland --verify-config -c ~/.config/hypr/hyprland.lua

require("conf.monitors")
require("conf.autostart")
require("conf.environment")

require("conf.appearance")
require("conf.animation")
require("conf.layout")
require("conf.misc")

require("conf.input")
require("conf.keybinding")

require("conf.windowrule")
require("conf.workspaces")
