---
name: agentic-workflow
description: Use to decide when and how to use this machine's agent toolkit - Lavish (visual planning), treehouse (worktrees), no-mistakes (PR gate), gnhf (overnight loops), First Mate (orchestrator), and AXI tools. Reach for this whenever a task could use parallel work, safe shipping, long autonomous runs, visual review, or GitHub/browser actions.
---

# Agentic workflow playbook

The full toolkit and the decision rules for using it. The setup, file locations, and
keybindings are documented in the user's vault (`Agentic Workflow/`) and in
`~/dotfiles/docs/`.

## When to reach for what
| If you are about to... | Use | Instead of |
|---|---|---|
| Present a plan, comparison, or review to the user | **Lavish** | a wall of terminal text |
| Run 2+ independent tasks on the same repo | **treehouse** | clobbering one working tree |
| Hand the user a finished, safe change | **no-mistakes** | pushing straight to origin |
| Take on a long, open-ended objective | **gnhf** | one giant turn |
| Coordinate work across several repos | **First Mate** | juggling tabs yourself |
| Read/write GitHub or drive a browser | **gh-axi / chrome-devtools-axi** | a heavy MCP server |

## Lavish (visual planning and review)
Write an interactive HTML artifact into `./.lavish/`, then `lavish-axi <file>` to open
it and `lavish-axi poll <file>` to wait for the user's annotations/choices. Match the
subject project's design system. Read the lavish ambient hook for full guidance.

## treehouse (parallel isolated worktrees)
`treehouse get --lease` prints a clean worktree path (no subshell) - work there so you
do not disturb the main checkout. `treehouse status` / `treehouse return <path>`.

## no-mistakes (validated-PR gate)
Per repo once: `no-mistakes init`. Then `git push no-mistakes <branch>` runs AI review,
tests, lint, and docs in a disposable worktree and opens a clean PR only if all pass;
it escalates ambiguous product decisions to the user. Watch with `no-mistakes`. The
`/no-mistakes` skill has the details.

## gnhf (overnight autonomous loop)
Prefer the capped wrapper: `gnhf-night "<objective>"` (40 iterations / 5M tokens /
sleep-prevention by default). Add `--stop-when "<condition>"`, `--worktree`, or
`--current-branch`. Never run uncapped.

## First Mate (multi-agent orchestrator)
`firstmate` launches it. Give it high-level goals spanning one or many repos; it spawns
crew agents in tmux windows over treehouse worktrees, runs each through no-mistakes, and
returns PRs, approved merges, or scout reports.

## Conventions to honor
- Memory is agent-agnostic in `AGENTS.md`; run `agents-init` to scaffold a new repo and
  append a lesson to its `AGENTS.md` whenever you make a mistake.
- Bug fixes start with an end-to-end reproduction script (see the `e2e-testing` skill).
- Never install unvetted skills. Prefer an AXI over an MCP server when one exists.
