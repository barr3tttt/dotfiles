#!/usr/bin/env bash
# Bootstrap the agentic workflow on a fresh Fedora (KDE/Wayland) machine.
# Idempotent-ish; safe to re-run. Review before running.
set -euo pipefail
DF="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== 1. System packages (sudo) =="
sudo dnf install -y stow ydotool xclip git gh nodejs cmake make gcc wl-clipboard
sudo dnf copr enable -y wezfurlong/wezterm-nightly && sudo dnf install -y wezterm

echo "== 2. User-space tools =="
command -v gitleaks >/dev/null || {
  TAG=$(curl -fsSL https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep -oP '"tag_name": "\K[^"]+')
  curl -fsSL "https://github.com/gitleaks/gitleaks/releases/download/${TAG}/gitleaks_${TAG#v}_linux_x64.tar.gz" | tar -xz -C "$HOME/.local/bin" gitleaks
}
npm install -g gh-axi chrome-devtools-axi lavish-axi gnhf
gh-axi setup hooks; chrome-devtools-axi setup hooks; lavish-axi setup hooks
npx -y skills@latest add kunchenguid/axi -g -y || true
curl -fsSL https://kunchenguid.github.io/treehouse/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh | sh
[ -d "$HOME/firstmate/.git" ] || git clone https://github.com/kunchenguid/firstmate "$HOME/firstmate"

echo "== 3. whisper.cpp (voice) =="
WC="$HOME/.local/share/whisper.cpp"
[ -d "$WC/.git" ] || git clone --depth 1 https://github.com/ggml-org/whisper.cpp "$WC"
( cd "$WC" && cmake -B build -DCMAKE_BUILD_TYPE=Release && cmake --build build -j --target whisper-cli \
  && sh ./models/download-ggml-model.sh base.en )
ln -sf "$WC/build/bin/whisper-cli" "$HOME/.local/bin/whisper-cli"

echo "== 4. Stow config packages =="
cd "$DF"
stow -v -t "$HOME" wezterm tmux scripts voice

echo "== 5. Agent memory + misc symlinks =="
ln -sf "$DF/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
mkdir -p "$HOME/.gemini" && ln -sf "$DF/agents/AGENTS.md" "$HOME/.gemini/GEMINI.md"
mkdir -p "$HOME/.config/agents" && ln -sf "$DF/agents/AGENTS.md" "$HOME/.config/agents/AGENTS.md"
ln -sf "$DF/agents/axi.md" "$HOME/.config/agents/axi.md"
mkdir -p "$HOME/.gnhf" && ln -sf "$DF/config/gnhf/config.yml" "$HOME/.gnhf/config.yml"
mkdir -p "$HOME/.config/treehouse" && ln -sf "$DF/config/treehouse/config.toml" "$HOME/.config/treehouse/config.toml"
mkdir -p "$HOME/.config/voice" && ln -sf "$DF/config/voice/vocab.txt" "$HOME/.config/voice/vocab.txt"

echo "== 6. Neovim overrides (LazyVim assumed installed) =="
cp "$DF/nvim-overrides/lua/config/keymaps.lua"  "$HOME/.config/nvim/lua/config/keymaps.lua"
cp "$DF/nvim-overrides/lua/plugins/rose-pine.lua" "$HOME/.config/nvim/lua/plugins/rose-pine.lua"
cp "$DF/nvim-overrides/lua/plugins/vim-tmux-navigator.lua" "$HOME/.config/nvim/lua/plugins/vim-tmux-navigator.lua"

echo "== 7. Skills (e2e-testing) =="
mkdir -p "$HOME/.claude/skills"
ln -sfn "$DF/skills/e2e-testing" "$HOME/.claude/skills/e2e-testing"

echo
echo "Done. For voice injection, also run install/ydotool-setup.sh and re-login,"
echo "then bind 'voice-dictate' to a KDE global shortcut."
