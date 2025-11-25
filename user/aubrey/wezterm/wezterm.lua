local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- i like it
config.tab_bar_at_bottom = true
config.color_scheme = 'AdventureTime'

-- an attempt to remove window decorations
config.window_decorations = "NONE | NONE"

-- fixes for bullshit
config.front_end = "WebGpu"

-- nushell supports it :)
config.enable_kitty_keyboard = true

-- it makes me happy when i fullscreen wezterm
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
