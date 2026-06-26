-- WezTerm configuration ("The Ship")
-- Keyboard-centric terminal. Cross-platform with conditional Lua logic and
-- instant hot-reload on save. Theme: rose-pine moon. tmux runs inside this.

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Conditional logic (the reason config is Lua, not static): detect platform.
local function is_linux() return wezterm.target_triple:find('linux') ~= nil end

-- ---------------------------------------------------------------- font
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'JetBrains Mono',
}
config.font_size = is_linux() and 12.0 or 13.0
config.line_height = 1.05

-- ---------------------------------------------------------------- theme (rose-pine moon)
config.color_scheme = 'rose-pine-moon'

-- ---------------------------------------------------------------- window
config.window_background_opacity = 1.0
config.window_decorations = 'TITLE | RESIZE'
config.window_padding = { left = 12, right = 12, top = 8, bottom = 8 }
config.initial_cols = 120
config.initial_rows = 32
config.adjust_window_size_when_changing_font_size = false

-- ---------------------------------------------------------------- tabs / cursor / scrollback
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.scrollback_lines = 10000
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ---------------------------------------------------------------- behavior
-- Hot-reload is on by default; make it explicit. Saving this file re-applies it.
config.automatically_reload_config = true
config.check_for_updates = false
config.audible_bell = 'Disabled'

-- ---------------------------------------------------------------- keys
-- Multiplexing is delegated to tmux; keep WezTerm bindings light.
config.keys = {
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = true } },
  -- font size
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
}

return config
