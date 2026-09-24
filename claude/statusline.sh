#!/usr/bin/env bash
# Claude Code status line launcher.
# Prefers firstmate's own fleet status line (bin/fm-claude-statusline.py) from
# whichever firstmate checkout this machine has, and falls back to the older
# standalone statusline.mjs when none is present. Reads the payload on stdin.
home="${FM_HOME:-$HOME/firstmate}"
for script in \
  "$home/bin/fm-claude-statusline.py" \
  "$home/projects/firstmate-gh/bin/fm-claude-statusline.py"; do
  if [ -f "$script" ] && command -v python3 >/dev/null 2>&1; then
    FM_HOME="$home" exec python3 "$script"
  fi
done
exec node "$HOME/.claude/statusline.mjs"
