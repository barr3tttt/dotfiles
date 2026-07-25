# dotfiles

High-level project memory for agents. Keep it current; append lessons on error.

## What this is
Barrett's personal dotfiles, deployed to ~ via GNU Stow (one top-level package per
tool). Public repo: no personal content, hosts, or secrets belong here.

## Repository map
- `bash/` - .bashrc.d fragments (aliases.sh, functions.sh, tools.sh, editor.sh)
- `starship/` - starship prompt config (Dracula, mac-matching)
- `blesh/`, `bat/`, `git/`, `btop/` - ble.sh faces, bat theme, delta include, btop theme
- `install/terminal-color.sh` - reproduces the whole color stack on a fresh machine
- `tmux/` - tmux.conf (Dracula status bar) + tpm plugins
- `wezterm/` - wezterm.lua (Dracula, mac palette)
- `nvim-overrides/` - LazyVim overrides
- `agents/`, `skills/`, `claude/`, `config/` - agent tooling and shared config
- `install/`, `scripts/`, `mac/`, `pi/` - setup scripts and per-machine bits
- `docs/` - tool guides (FIRSTMATE, LAVISH, VOICE, ...)

## Terminology
- "AXI" - agent-ergonomic CLI wrappers (gh-axi, lavish-axi, chrome-devtools-axi)
- Theme baseline: Dracula on both machines (Ship re-themed 2026-07-25 to match mac); rose-pine assets kept in-repo for switch-back

## Runtime conventions
- Deploy: `stow <package>` from repo root (configs in ~ are symlinks into here)
- Verify shell changes with a fresh interactive shell, not the current one

## Skills available
<list project skills the agent may activate, with a one-line trigger each>

## Lessons (append-only)
When you make an implementation mistake, add a dated, one-line lesson here so it is
not repeated.
- 2026-07-25: util-linux `script` is not installed on this machine; to e2e-test
  interactive shell behavior (ble.sh, prompts), spawn `bash -i` under Python's
  `pty` module and assert on the captured escape sequences.
- 2026-07-24: In starship.toml (any TOML), root-level keys like `palette = '...'`
  must appear BEFORE the first `[section]` header. `palette` placed after
  `[palettes.rose-pine-moon]` became a key inside that table, the palette never
  activated, and starship silently dropped every named-color style, leaving the
  prompt colorless. Verify with: `starship prompt | cat -v` (expect `38;2;R;G;B`
  escapes).
