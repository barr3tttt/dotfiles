# dotfiles

Agentic engineering workflow for **Fedora 44 (KDE / Wayland)** (the "Ship"),
plus a **macOS** host package (`mac/`). Agent-agnostic, currently driven with
Claude Code. Managed with GNU Stow.

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
mac/       -> ~ (macOS host)             macOS: WezTerm (Dracula) + tmux + zsh + starship
```

The Linux Ship is themed rose-pine-moon; the macOS host is themed Dracula and
runs tmux-as-multiplexer inside a chrome-less WezTerm. They are intentionally
separate stow packages — neither overwrites the other.

## Install on a fresh machine
```bash
git clone https://github.com/barr3tttt/dotfiles ~/dotfiles
cd ~/dotfiles
bash install/bootstrap.sh        # installs tools (see script for sudo steps)
stow wezterm tmux agents scripts voice      # Linux "Ship"
```

### macOS host
```bash
# work/machine-specific bits (AWS profiles, work paths) live in ~/.zshrc.local
# (gitignored). Create that file before/after stowing if needed.
cd ~/dotfiles
stow -t ~ mac        # symlinks ~/.zshrc, ~/.tmux.conf, ~/.config/{starship.toml,wezterm}
# tmux plugins: TPM auto-clones on first launch; press prefix+I to install.
# wezterm wallpapers are not tracked — drop images in ~/.config/wezterm/backdrops/
```

## Tools installed
WezTerm · tmux · Neovim (LazyVim) · Claude Code · npx skills · AXI (gh-axi) ·
lavish-axi · treehouse · no-mistakes · gnhf · firstmate · whisper.cpp dictation.

## Safety
Public repo. A `gitleaks` pre-commit hook + strict `.gitignore` keep credentials,
tokens, ssh keys, and agent state out of history. Never commit secrets.
