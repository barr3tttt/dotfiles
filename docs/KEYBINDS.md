# Keybinds (WezTerm + tmux)

The terminal stack is two layers: WezTerm is the outer window, tmux runs inside it
and owns multiplexing. The split keys are deliberately mirrored (`|` and `-` behave
the same in both layers) so the muscle memory carries whether or not you are in tmux.

Sources: `wezterm/.config/wezterm/wezterm.lua`, `tmux/.config/tmux/tmux.conf`.

## WezTerm

Only the keys below override defaults; everything else (copy/paste, scrollback) is
WezTerm's built-in default.

| Key | Action |
| --- | --- |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab (confirm) |
| `Ctrl+Shift+\|` | Split pane right (side-by-side) |
| `Ctrl+Shift+-` | Split pane below (stacked) |
| `Ctrl+=` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |

Note: WezTerm's `SplitVertical` puts the new pane below; `SplitHorizontal` puts it to
the right. The bindings above hide that naming behind the `|` / `-` glyphs.

## tmux

Prefix is remapped to `Ctrl+A` (default `Ctrl+B` is unbound). Press prefix, release,
then the key. `Ctrl+A Ctrl+A` sends a literal `Ctrl+A` through to the app.

| Key | Action |
| --- | --- |
| `prefix R` | Reload tmux config |
| `prefix \|` | Split window right (keeps current path) |
| `prefix -` | Split window below (keeps current path) |
| `prefix C` | New window (keeps current path) |
| `prefix H` / `J` / `K` / `L` | Move to pane left / down / up / right |
| `prefix Shift+H/J/K/L` | Resize pane (repeatable, hold and tap) |
| `prefix N` / `P` | Next / previous window (repeatable) |

Copy mode (vi-style):

| Key | Action |
| --- | --- |
| `V` | Begin selection |
| `Y` | Copy selection and exit copy mode |

The default tmux split keys (`"` and `%`) are unbound in favor of `|` and `-`.

## Neovim

Neovim has its own large keymap set under `nvim-overrides/`; it is not duplicated here.
