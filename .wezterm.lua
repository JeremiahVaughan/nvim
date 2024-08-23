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
-- and finally, return the configuration to wezterm
return config
