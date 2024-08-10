-- This is for Adrien's Madcbook config, not Digital Ocean

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("RobotoMono Nerd Font Mono")
config.font_size = 17

-- Tokyonight, of course
config.color_scheme = "tokyonight"

-- Hide the tab bar
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- Full screen
config.native_macos_fullscreen_mode = true
config.keys = {
	{
		key = "f",
		mods = "CMD|CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
}

-- and finally, return the configuration to wezterm
return config
