#!/usr/bin/env bash
# Terminal color stack (dracula): ble.sh, bat, fzf, vivid LS_COLORS,
# delta, btop theme, tealdeer. Idempotent; safe to re-run. Fedora-specific.
# Configs are stowed from the repo; this script installs the binaries and
# runs the one-time wiring steps.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> dnf packages (git-delta, tealdeer)"
if ! command -v delta >/dev/null || ! command -v tldr >/dev/null; then
  sudo dnf install -y git-delta tealdeer
fi

echo "==> ble.sh (line editor: syntax highlighting + autosuggestions)"
if [ ! -f "$HOME/.local/share/blesh/ble.sh" ]; then
  tmp="$(mktemp -d)"
  git clone --recursive --depth 1 https://github.com/akinomyoga/ble.sh.git "$tmp/ble.sh"
  make -C "$tmp/ble.sh" install PREFIX="$HOME/.local"
  rm -rf "$tmp"
fi
if ! grep -q 'blesh/ble.sh' "$HOME/.bashrc"; then
  echo "NOTE: add the two ble.sh lines to ~/.bashrc (see docs/TERMINAL.md):"
  echo '  top:    [[ $- == *i* ]] && [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh --noattach'
  echo '  bottom: [[ ! ${BLE_VERSION-} ]] || ble-attach'
fi

echo "==> vivid (LS_COLORS generator; not packaged on Fedora)"
if ! command -v vivid >/dev/null; then
  url="$(curl -fsSL https://api.github.com/repos/sharkdp/vivid/releases/latest \
    | grep -oE '"browser_download_url": "[^"]*x86_64-unknown-linux-musl[^"]*"' \
    | cut -d'"' -f4)"
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/vivid.tgz" "$url"
  tar xzf "$tmp/vivid.tgz" -C "$tmp"
  install -m755 "$tmp"/vivid-*/vivid "$HOME/.local/bin/vivid"
  rm -rf "$tmp"
fi

echo "==> stow config packages"
(cd "$DOTFILES" && stow --restow bash starship blesh bat git btop wezterm tmux)

echo "==> bat theme cache"
bat cache --build >/dev/null

echo "==> delta gitconfig include (guarded: pager errors if delta missing)"
if command -v delta >/dev/null; then
  git config --global include.path '~/.config/git/delta.gitconfig'
fi

echo "==> btop theme"
if [ -f "$HOME/.config/btop/btop.conf" ]; then
  sed -i 's/^color_theme = .*/color_theme = "dracula"/' "$HOME/.config/btop/btop.conf"
else
  mkdir -p "$HOME/.config/btop"
  echo 'color_theme = "dracula"' > "$HOME/.config/btop/btop.conf"
fi

echo "==> tealdeer cache"
command -v tldr >/dev/null && tldr --update >/dev/null

echo "Done. Open a new shell (or new WezTerm window) to see it all."
