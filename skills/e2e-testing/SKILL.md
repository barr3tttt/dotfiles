---
name: e2e-testing
description: Use when fixing a bug or verifying a behavior change. Produces an end-to-end reproduction script that mirrors the real user experience and proves the fix, instead of relying on shallow unit tests.
---

# End-to-end reproduction testing

This skill is the full procedure deliberately kept OUT of the global AGENTS.md so it
does not cost system-prompt tokens until activated (progressive disclosure).

## When to use
- A bug report or unexpected behavior.
- Any change where "it works" must be demonstrated, not asserted.

## Procedure
1. Reproduce first. Write a script (shell, or the project's test runner driving the
   real entry point) that exercises the actual user path and FAILS on the current bug.
   Drive the real interfaces (HTTP endpoint, CLI command, UI action) - not an internal
   function in isolation.
2. Confirm the script fails for the right reason. Capture the failing output.
3. Find and fix the root cause. Do not patch the symptom.
4. Re-run the same script unchanged. Confirm it now passes.
5. Capture evidence: the before/after script output, and for UI work a screenshot or
   short recording. Store it with the change.
6. Add the script to the project's test suite so the regression stays caught.

## Anti-patterns
- A unit test that mocks away the failing layer. If the bug lives in integration, the
  test must integrate.
- Asserting success without running anything. Evidence before assertions, always.

## Output
A committed reproduction script + captured before/after evidence, plus a one-line
lesson appended to the project AGENTS.md if the bug revealed a systemic gap.
