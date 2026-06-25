# dotfiles

Agentic engineering workflow for **Fedora 44 (KDE / Wayland)**. Agent-agnostic,
currently driven with Claude Code. Managed with GNU Stow.

> Full design: [`docs/SPEC.md`](docs/SPEC.md)

## Layout (GNU Stow packages)
```
wezterm/   -> ~/.config/wezterm/        WezTerm config (rose-pine-moon, hot-reload)
tmux/      -> ~/.config/tmux/           tmux: detach server, minimal status bar
agents/    -> ~/.config/agents/         AGENTS.md (agent-agnostic memory, ~27 lines)
scripts/   -> ~/.local/bin/             helper scripts + shims
voice/     -> ~/.local/bin/             Whisper push-to-talk dictation
nvim-overrides/                          tracked copies of LazyVim customizations
install/                                 setup scripts (per phase)
```

## Install on a fresh machine
```bash
git clone https://github.com/barr3tttt/dotfiles ~/dotfiles
cd ~/dotfiles
bash install/bootstrap.sh        # installs tools (see script for sudo steps)
stow wezterm tmux agents scripts voice
```

## Tools installed
WezTerm · tmux · Neovim (LazyVim) · Claude Code · npx skills · AXI (gh-axi) ·
lavish-axi · treehouse · no-mistakes · gnhf · firstmate · whisper.cpp dictation.

## Safety
Public repo. A `gitleaks` pre-commit hook + strict `.gitignore` keep credentials,
tokens, ssh keys, and agent state out of history. Never commit secrets.
