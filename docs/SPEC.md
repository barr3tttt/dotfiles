# Agentic Engineering Workflow — Fedora Build Spec

Recreation of a macOS agentic-engineering workflow, translated to **Fedora 44 (KDE Plasma / Wayland)**.
Agent-agnostic by design; currently driven with Claude Code.

## Mental model
Operate as an engineering director: define workflows, pipelines, and objective
"treasure maps" for agents instead of writing lines by hand. Replace terminal
text-walls with rich, visual, interactive local artifacts (see Lavish).

## Machine baseline (audited 2026-06-25)
- Fedora 44 KDE Plasma, Wayland, bash.
- Present: tmux 3.6b, Neovim 0.12.2 (LazyVim), Claude Code 2.1.x, Gemini CLI,
  node 22 (nvm), python 3.14, fzf/rg/fd/bat/zoxide/starship, gh (authed: barr3tttt).
- Replaced: Flatpak WezTerm (old, sandboxed home:ro) -> native WezTerm (COPR).

## macOS -> Fedora translations
| Video (macOS)            | Fedora                                                        |
|--------------------------|---------------------------------------------------------------|
| Homebrew                 | dnf + curl/npm user-space installers                          |
| OpenSuperWhisper (Mac)   | whisper.cpp + ydotool + wl-clipboard + KDE custom shortcut    |
| pbcopy / open / launchd  | wl-copy / xdg-open / systemd (shims where needed)             |
| Flatpak WezTerm          | native WezTerm (COPR wezfurlong/wezterm-nightly)              |

## Components
1. **Terminal infra ("The Ship")**: WezTerm (rose-pine-moon, hot-reload) + tmux
   (detach/reattach server, minimal status bar) + Neovim (LazyVim; relative
   numbers; `space s` grep, `space f` find files).
2. **Agent knowledge ("The Crew")**: agent-agnostic `AGENTS.md` (~27 lines) as the
   single source of truth; `CLAUDE.md`/`GEMINI.md` symlinked to it. Core rules:
   plain dashes (no em-dash), discount human dev-time estimates, bug fixes start
   with an end-to-end reproduction script. Project-level AGENTS.md template that
   appends lessons on error. Progressive-disclosure **skills** via `npx skills`.
3. **AXI** (Agent eXperience Interface): token-efficient CLI convention. Install
   gh-axi (+ optional chrome-devtools-axi); index in `axi.md`.
4. **Lavish**: local interactive HTML canvas for visual planning/review.
5. **Worktrees & loops**: treehouse (worktree pool), no-mistakes (validated-PR
   pipeline), gnhf (overnight autonomous loop).
6. **First Mate**: multi-agent orchestrator over tmux + treehouse worktrees.
7. **Voice**: Whisper-based push-to-talk dictation with custom vocabulary prompt.

## Tool sources (all MIT, cross-platform)
- npx skills: github.com/vercel-labs/skills
- AXI: axi.md, github.com/kunchenguid/axi, gh-axi, chrome-devtools-axi
- lavish-axi: github.com/kunchenguid/lavish-axi
- no-mistakes: github.com/kunchenguid/no-mistakes (Go)
- treehouse: github.com/kunchenguid/treehouse (Go)
- gnhf: github.com/kunchenguid/gnhf (Node)
- firstmate: github.com/kunchenguid/firstmate (bash)

## Safety
- Public repo: gitleaks pre-commit hook + strict .gitignore denylist. No
  credentials, tokens, ssh keys, or agent state are ever tracked.
- Skills guardrail: never install unverified community skills (credential-leak
  and quality risks). Only the vetted tools above.

## Constraints / decisions
- Native WezTerm replaces the Flatpak (sandbox broke browser-launch + file writes).
- Agent-agnostic architecture, Claude-only installs for now (Codex/OpenCode trivial
  to add later via the same AGENTS.md + skills).
- Voice is a first-class phase; the Mac app is rebuilt from Linux parts.
