-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- allow shift+enter to be sent to nvim
config.keys = {
    { key = "\r", mods = "SHIFT", action = wezterm.action.SendKey { key = '\r', mods = 'SHIFT' } }
}
config.font_size = 20
config.hide_tab_bar_if_only_one_tab = true

if wezterm.target_triple:find("windows") then
    config.default_prog = { "powershell", "-NoLogo" }
else
    config.default_prog = { "/usr/bin/zsh" }
end

local mux = wezterm.mux

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

return config
