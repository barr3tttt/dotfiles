# Lavish (visual canvas planning)

`lavish-axi` turns rich HTML artifacts into a collaborative human-review surface in a
local browser: the agent generates an interactive HTML page, serves it locally, and you
annotate elements, pick options, and queue feedback that flows straight back to the
agent. Replaces walls of terminal text for planning and review.

## Workflow
1. Agent writes an HTML artifact into `./.lavish/` (matching the subject project's
   design system; falls back to Tailwind v4 + DaisyUI v5 CDN).
2. `lavish-axi <html-file>` - serves it (local express server) and opens the browser.
3. `lavish-axi poll <html-file>` - long-polls for your feedback (leave running).
4. `lavish-axi end <html-file>` / `lavish-axi stop` - end session / stop server.
5. `lavish-axi playbook <id>` - focused guidance (diagram, table, comparison, plan,
   code, input, slides). `lavish-axi design` - CDN snippet.

## Integration
- SessionStart hooks installed for Claude Code, Codex, OpenCode (ambient context).
- Env: `LAVISH_AXI_HOST`, `LAVISH_AXI_IDLE_TIMEOUT_MS`, `LAVISH_AXI_DEBUG`.

## Verified
- Server start/serve/stop confirmed (port auto-assigned, e.g. 127.0.0.1:4387).
- Full visual render + annotate loop: test interactively in a browser.
