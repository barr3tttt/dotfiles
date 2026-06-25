# Skills (progressive disclosure)

Skills move conditional, lengthy instructions OUT of the always-loaded AGENTS.md so
they cost no system-prompt tokens until activated. The agent reads only the short
`description:` header at boot, and the full body only when it activates the skill.

## Manage with `npx skills` (agent-agnostic, vercel-labs/skills)
- `npx skills list` - list installed skills
- `npx skills add <owner>/<repo>` - install a skill package
- `npx skills find <query>` - search
- `npx skills init <name>` - scaffold a new skill (`<name>/SKILL.md`)
- `npx skills update` - update installed skills

Skills use the `SKILL.md` format (YAML frontmatter + body) understood by Claude Code,
Codex, OpenCode, Gemini, and others.

## Local skills
- `e2e-testing` - end-to-end reproduction testing procedure (canonical copy in
  `~/dotfiles/skills/`, symlinked into `~/.claude/skills/`).

## SECURITY GUARDRAIL
Never install arbitrary, unverified community skills. A malicious skill can exfiltrate
local credentials and banking/API tokens, degrade output quality, and inflate token
usage. Only install skills from sources you have personally vetted (the named AXI tools
and your own skills). When in doubt, read the SKILL.md before installing.
