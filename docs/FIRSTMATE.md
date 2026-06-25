# First Mate (multi-agent orchestrator)

You talk to one agent - the first mate - and it runs a crew: spawning autonomous
agents in tmux windows, each in a clean treehouse worktree, supervising them to
completion, and handing back finished PRs (through the no-mistakes gate), approved
local merges, or investigation reports. There is no app; the orchestrator is
`AGENTS.md` + bundled skills + helper scripts in the cloned repo.

## Location
Cloned to `~/firstmate` (upstream repo, not tracked in dotfiles).
Update with `git -C ~/firstmate pull` or its `/updatefirstmate` skill.

## Launch
```
firstmate          # cd ~/firstmate && claude   (launcher on PATH)
```
Then speak high-level goals spanning one or many repos, e.g. "apply this CLI flag
across these three projects and open PRs". Use `/afk` for unattended supervision.

## Readiness on this machine (verified)
`bin/fm-bootstrap.sh` detection is silent (exit 0): tmux, node, gh (authed),
treehouse (with --lease), no-mistakes, gh-axi, chrome-devtools-axi, lavish-axi all
present. No macOS-specific code in firstmate; no shims required by it.

## Task types
- ship - deliver via PR or approved local merge.
- scout - investigate and report.

## Notes
- Crew windows live in tmux; keep a tmux server running.
- `pbcopy`/`pbpaste` Wayland shims are installed globally for any mac-trained tooling.
