#!/usr/bin/env bash
# Claude Code status line launcher.
# Prefers firstmate's fleet status line (bin/fm-claude-statusline.py) from
# whichever firstmate checkout this machine has, and falls back to the
# standalone statusline.mjs when none is present. Reads the payload on stdin.
#
# That renderer is not read-only: it starts background cost refreshes that
# write caches and a spend-alarm check script into its state directory. So it
# runs against a shadow state directory made of symlinks to the real firstmate
# state: it reads the real fleet through the links, while everything it writes
# lands in the shadow directory and never touches the live supervision state.
home="${FM_HOME:-$HOME/firstmate}"
real="$home/state"
shadow="${XDG_CACHE_HOME:-$HOME/.cache}/fm-statusline-state"
for script in \
  "$home/bin/fm-claude-statusline.py" \
  "$home/projects/firstmate-gh/bin/fm-claude-statusline.py"; do
  if [ -f "$script" ] && [ -d "$real" ] && command -v python3 >/dev/null 2>&1; then
    mkdir -p "$shadow"
    for f in "$real"/* "$real"/.[!.]*; do
      [ -e "$f" ] || continue
      name=${f##*/}
      case "$name" in
        spend-alarm.check.sh|.spend-alarm*|.ai-cost-*|.nm-cost-*) continue ;;
      esac
      [ -e "$shadow/$name" ] || [ -L "$shadow/$name" ] || ln -s "$f" "$shadow/$name"
    done
    for l in "$shadow"/* "$shadow"/.[!.]*; do
      [ -L "$l" ] && [ ! -e "$l" ] && rm -f "$l"
    done
    FM_HOME="$home" FM_STATE_OVERRIDE="$shadow" exec python3 "$script"
  fi
done
exec node "$HOME/.claude/statusline.mjs"
