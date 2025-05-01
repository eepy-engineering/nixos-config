local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- enforce nushell supremacy
config.default_prog = { "nu" }

-- i like it
config.tab_bar_at_bottom = true
config.color_scheme = 'AdventureTime'

-- an attempt to remove window decorations
config.window_decorations = "NONE | NONE"

-- fixes for bullshit
config.front_end = "WebGpu"

-- nushell supports it :)
config.enable_kitty_keyboard = true

return config
