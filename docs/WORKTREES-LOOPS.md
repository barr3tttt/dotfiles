# Worktrees, validation gate, and overnight loops

## treehouse - parallel worktree pool
Hands out reusable, pre-warmed git worktrees so multiple agents work the same repo
in parallel without re-cloning.
- `treehouse get` - acquire a worktree and open a subshell in it.
- `treehouse get --lease` - acquire without a subshell (for agents); prints the path.
- `treehouse return <path>` / `treehouse status` / `treehouse prune`.
- Config: per-repo `treehouse.toml` (`treehouse init`); user defaults in
  `~/.config/treehouse/config.toml` (tracked: `config/treehouse/config.toml`).
- Verified: lease + status + cleanup on a throwaway repo.

## no-mistakes - validated-PR gate
A local git proxy in front of your real remote. Push to it and it runs an AI
validation pipeline (review, e2e tests, docs, lint) in a disposable worktree, then
forwards a clean PR only after checks pass.
- `no-mistakes init` (per repo) - adds a `no-mistakes` remote + `/no-mistakes` skill.
- `git push no-mistakes <branch>` - push through the gate.
- `no-mistakes` (no args) - watch the run. `no-mistakes doctor` - check prereqs.
- Verified: doctor all-green (git, gh, daemon, claude); init creates the gate remote.

## gnhf - overnight autonomous loop ("good night, have fun")
Runs an agent in a loop toward a high-level objective, committing small verified
changes until a stop condition or runtime cap is hit.
- `gnhf "objective"` - start a loop (creates a `gnhf/` branch).
- `gnhf-night "objective"` - wrapper with strict default caps (40 iterations,
  5M tokens, sleep-prevention on). Override with `GNHF_MAX_ITER` / `GNHF_MAX_TOKENS`.
- `--stop-when "<condition>"`, `--worktree`, `--current-branch`, `--push`.
- Config: `~/.gnhf/config.yml` (tracked: `config/gnhf/config.yml`); agent=claude.
- Verified: config loads, mock loop starts.

## Safety
Always run gnhf with caps (use `gnhf-night`). no-mistakes escalates ambiguous product
decisions to you instead of guessing. Worktrees isolate parallel agents from each other.
