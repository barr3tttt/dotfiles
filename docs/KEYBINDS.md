# Keybinds (WezTerm + tmux)

The terminal stack is two layers: WezTerm is the outer window, tmux runs inside it
and owns multiplexing. All splitting and pane navigation happens in tmux; WezTerm
deliberately has no split keys so the two layers never nest confusingly. Pane
navigation is unified across tmux and Neovim via vim-tmux-navigator: `Ctrl+h/j/k/l`
moves between nvim splits and tmux panes with no prefix.

Sources: `wezterm/.config/wezterm/wezterm.lua`, `tmux/.config/tmux/tmux.conf`.

## WezTerm

Only the keys below override defaults; everything else (copy/paste, scrollback) is
WezTerm's built-in default.

| Key | Action |
| --- | --- |
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+W` | Close tab (confirm) |
| `Ctrl+=` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |

WezTerm has no split keys on purpose: splitting is tmux's job, so panes never nest
across the two layers.

## tmux

Prefix is remapped to `Ctrl+A` (default `Ctrl+B` is unbound). Press prefix, release,
then the key. `Ctrl+A Ctrl+A` sends a literal `Ctrl+A` through to the app.

| Key | Action |
| --- | --- |
| `prefix R` | Reload tmux config |
| `prefix \|` | Split window right (keeps current path) |
| `prefix -` | Split window below (keeps current path) |
| `prefix C` | New window (keeps current path) |
| `Ctrl+H` / `J` / `K` / `L` | Move between panes / nvim splits (no prefix, seamless) |
| `prefix H` / `J` / `K` / `L` | Move to pane left / down / up / right (prefix fallback) |
| `prefix Shift+H/J/K/L` | Resize pane (repeatable, hold and tap) |
| `prefix Ctrl+L` | Clear screen (since bare Ctrl+L now navigates) |
| `prefix N` / `P` | Next / previous window (repeatable) |
| `prefix Z` | Zoom pane fullscreen (toggle) |
| `prefix X` | Close pane |
| `prefix D` | Detach (work keeps running; `tmux attach` to return) |
| `prefix F` | Fuzzy project switcher (popup; jump to a repo as a session) |
| `prefix G` | Switch between existing sessions (fzf popup) |

Copy mode (vi-style):

| Key | Action |
| --- | --- |
| `V` | Begin selection |
| `Y` | Copy selection and exit copy mode |

The default tmux split keys (`"` and `%`) are unbound in favor of `|` and `-`.

Plugins (via tpm, auto-installed by bootstrap): **tmux-resurrect** + **tmux-continuum**
give reboot persistence - sessions auto-save every 15 min and auto-restore when the
tmux server starts. `prefix Ctrl+S` saves manually, `prefix Ctrl+R` restores. The
`prefix F` switcher is `scripts/tmux-sessionizer` (edit its `SEARCH_ROOTS` to point at
where you keep projects).

## Neovim

Built on LazyVim, so the leader key is `Space` and the bulk of the keymap is
LazyVim's defaults (see https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua).
Only the overrides in `nvim-overrides/lua/config/keymaps.lua` are listed here.

| Key | Action |
| --- | --- |
| `<leader>f` | Find files by fuzzy name, from project root |
| `<leader>s` | Project-wide text search / live grep, from root |
| `Ctrl+H` / `J` / `K` / `L` | Move between nvim splits and tmux panes (vim-tmux-navigator) |

Both bind the bare leader key directly (a single keystroke after `Space`),
intentionally shadowing LazyVim's `<leader>f..` / `<leader>s..` which-key groups so
the two most common actions are fastest. They dispatch through `LazyVim.pick`, so
they use the configured picker (Telescope) and respect the project root.
