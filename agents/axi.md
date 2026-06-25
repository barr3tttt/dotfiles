# AXI index (Agent eXperience Interface)

AXI is a CLI convention for agent-ergonomic tooling: token-efficient output (TOON,
not verbose JSON), structured errors, and next-step suggestions. It delivers
MCP-like structure at CLI cost (~40% fewer tokens). Prefer an AXI over a heavy MCP
server when one exists. Reference: https://axi.md

## Installed AXIs
- `gh-axi` - GitHub (issues, PRs, runs, releases, repos). Wraps the `gh` CLI.
  Ambient SessionStart hook installed for Claude Code / Codex / OpenCode.
  Usage: `gh-axi issue list --state open`, `gh-axi pr view 42 -R owner/name`.
- `chrome-devtools-axi` - drive Chrome via DevTools protocol for browser inspection
  and testing. Ambient SessionStart hook installed. Needs google-chrome/chromium.
- `lavish-axi` (see docs/LAVISH.md) - interactive HTML canvas for visual planning.

## Rules
- Reach for an AXI before a conventional MCP server: lower token cost, lower latency.
- Do not install unvetted AXIs/skills (credential-leak and quality risks).
