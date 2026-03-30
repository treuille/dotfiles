-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()


-- This is where you actually apply your config choices
config.font = wezterm.font {
  family = 'RobotoMono Nerd Font Mono',
  weight = 'Regular',
}
config.font_size = 17

-- Font rules to override thin/extralight weights
config.font_rules = {
  -- Rule for Half intensity (dim) text - use Regular weight instead of ExtraLight
  {
    intensity = 'Half',
    italic = false,
    font = wezterm.font {
      family = 'RobotoMono Nerd Font Mono',
      weight = 'Light', -- Using Regular instead of the default ExtraLight
    },
  },
  
  -- If you also need to handle italic dim text
  {
    intensity = 'Half',
    italic = true,
    font = wezterm.font {
      family = 'RobotoMono Nerd Font Mono',
      weight = 'Light', -- Using Regular instead of the default ExtraLight
      italic = true,
    },
  },
}

-- Tokyonight, of course
-- config.color_scheme = 'tokyonight'
config.color_scheme = 'Catppuccin Mocha'

-- Hide the tab bar
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

-- Full screen
config.native_macos_fullscreen_mode = true
config.keys = {
  {
    key = 'f',
    mods = 'CMD|CTRL',
    action = wezterm.action.ToggleFullScreen,
  },
}

-- Make a more subtle visual bell.
-- This isn't really working. I'm not sure what's wrong.
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 75,
  fade_out_function = "EaseIn",
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}
config.audible_bell = "Disabled"
config.colors = {
  visual_bell = '#ea7384',
}

-- CMD-click opens the link under the mouse cursor
-- This avoids an issue where I couldn't click on links in TMUX
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}
config.bypass_mouse_reporting_modifiers = "CMD"

-- Let `alt` work properly in the terminal 
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- and finally, return the configuration to wezterm
return config
