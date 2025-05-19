-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = { '/opt/homebrew/bin/nu', '-l' }
config.color_scheme = 'Lunaria Light (Gogh)'
local scheme = wezterm.color.get_builtin_schemes()[config.color_scheme]
config.use_fancy_tab_bar = true

config.font = wezterm.font('VCTR Mono v0.12', { })
config.font_size = 13.0

local bgcolor = wezterm.color.parse(scheme.background)

config.window_frame = {
    font = wezterm.font { family = 'Inter', weight = 'Bold' },
    -- The size of the font in the tab bar.
    -- Default to 10.0 on Windows but 12.0 on other systems
    font_size = 12.0,
  
    -- The overall background color of the tab bar when
    -- the window is focused
    active_titlebar_bg = bgcolor:darken(0.1),
  
    -- The overall background color of the tab bar when
    -- the window is not focused
    inactive_titlebar_bg = bgcolor:darken(0.05),
  }

config.colors = {
    tab_bar = {
        active_tab = {bg_color = bgcolor:darken(0.3), fg_color = "white"},
        new_tab = {bg_color = bgcolor:darken(0.3), fg_color = "white"},
    }
}

-- Make file paths in Python stack traces clickable
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
    regex = [[File "([^"]+)", line (\d+)]],
    format = 'vscode://file/$1:$2',
  })

return config