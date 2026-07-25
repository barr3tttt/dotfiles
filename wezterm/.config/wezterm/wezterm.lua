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
-- Tab bar off (mac parity): tmux owns all multiplexing chrome.
config.enable_tab_bar = false
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 650
config.cursor_blink_ease_in = 'EaseOut'
config.cursor_blink_ease_out = 'EaseOut'
config.scrollback_lines = 10000
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- ---------------------------------------------------------------- rendering (mac parity)
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.max_fps = 120
config.animation_fps = 120

-- ---------------------------------------------------------------- bells / palette chrome
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 250,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 250,
  target = 'CursorColor',
}
-- command palette (Ctrl+Shift+P) in rose-pine moon
config.command_palette_bg_color = '#2a273f'
config.command_palette_fg_color = '#e0def4'
config.command_palette_font_size = 12
config.command_palette_rows = 20

-- ---------------------------------------------------------------- behavior
-- Hot-reload is on by default; make it explicit. Saving this file re-applies it.
config.automatically_reload_config = true
config.check_for_updates = false
config.audible_bell = 'Disabled'

-- ---------------------------------------------------------------- frosted glass
-- Translucent window so the desktop shows through. The "frosted" blur is applied
-- by the compositor, not WezTerm: macOS gets it natively below; on Linux/KWin the
-- window must be blurred by the Force Blur effect (kwin-effects-forceblur), since
-- stock KWin blur ignores apps that don't request it (WezTerm doesn't).
-- Lower OPACITY = more see-through. tmux pane bodies use the default background,
-- which inherits this translucency; the rose-pine status bar stays solid on top.
local OPACITY = 0.78
config.window_background_opacity = OPACITY
config.macos_window_background_blur = 20  -- macOS only; ignored elsewhere

-- Ctrl+Shift+B: toggle between translucent and fully opaque for the focused window.
wezterm.on('opacity-toggle', function(window)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = 1.0
  end
  window:set_config_overrides(overrides)
end)

-- ---------------------------------------------------------------- keys
-- Multiplexing is delegated to tmux (tab bar disabled above); WezTerm keeps
-- only window-level bindings.
config.keys = {
  -- translucency
  { key = 'b', mods = 'CTRL|SHIFT', action = wezterm.action.EmitEvent 'opacity-toggle' },
  -- font size
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
}

return config
