# claude/ — Claude Code status line

Custom status bar for Claude Code: model, context-window gauge, session
tokens/cost, lines changed, and subscription rate-limit gauges (5-hour +
weekly, same data as `/usage`).

```
🧠 Fable 5 │ ⛁ ━━─── 34% │ 🪙 51.2k/8.4k │ 💵 $1.42 │ +214/-38 │ 🗓 5h ━━──────── 18% · wk ━━━━━━──── 62%
```

Dependency-free Node script; everything comes from the JSON Claude Code
(v2.1.132+) pipes on stdin. No network calls. Missing fields drop their
segment (rate limits appear after the session's first API response); bad
input falls back to a bare model name.

## Install on a new machine

```bash
ln -sf ~/dotfiles/claude/statusline.mjs ~/.claude/statusline.mjs
```

(`install/bootstrap.sh` does this on the Ship.)

Then add to `~/.claude/settings.json` (not tracked — it holds machine
secrets):

```json
"statusLine": {
  "type": "command",
  "command": "node ~/.claude/statusline.mjs"
}
```

## Try it

```bash
echo '{"model":{"display_name":"Test"},"context_window":{"used_percentage":42}}' \
  | node ~/dotfiles/claude/statusline.mjs
```
