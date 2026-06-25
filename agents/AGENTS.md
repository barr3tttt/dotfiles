# Global agent rules (agent-agnostic source of truth)

Keep this file short. It is loaded into every system prompt; every line costs tokens.

## Formatting
- Write with plain ASCII dashes. Never use the em-dash or en-dash. No decorative unicode.
- Prefer prose and short lists over heavy tables and box-drawing in terminal output.

## Engineering judgment
- Do not weigh human development time when choosing an architecture. You are not
  constrained by human hours, so do not default to a cheap, low-quality, "fast"
  design. Choose the correct, scalable, well-factored solution and build it.
- Match the surrounding code: its naming, idioms, and comment density.

## Debugging
- Start every bug fix by writing an end-to-end reproduction script that mirrors the
  real user experience and fails on the bug. Do not rely on shallow unit tests.
- Confirm the repro fails, fix the cause, then confirm the repro passes.

## Workflow
- Prefer rich, interactive local artifacts (Lavish canvas) over walls of terminal text
  for planning and review.
- When you make an implementation mistake, append the lesson to the project AGENTS.md so
  it is not repeated.

## Safety
- Never install unverified third-party agent skills. They can exfiltrate credentials and
  degrade output. Only use vetted, named tools.
