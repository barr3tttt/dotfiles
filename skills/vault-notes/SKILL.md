---
name: vault-notes
description: Use when creating, editing, or organizing notes in the user's personal Obsidian vault at ~/Documents/Vault. Covers the off-limits Personal folder, Obsidian formatting, structure, and naming conventions.
---

# Creating notes in the Obsidian vault

The personal vault is **`~/Documents/Vault`** (an Obsidian vault + private git repo).
Other vaults exist (`~/Documents/Work Vault`, `~/Documents/Hard Drive/Main Vault`);
"the vault" means the personal one unless told otherwise. Do not touch other vaults
unless explicitly asked.

## HARD RULE: off-limits areas
- **NEVER read, list, open, write, move, or modify anything under `Personal/`.**
  It holds private journals and personal records. Treat it as if it does not exist,
  even when searching or globbing - exclude it from every operation.
- Do not run vault-wide searches/greps that would surface `Personal/` contents.
- When unsure whether a folder is private, ask before reading it.

## Where new notes go
- Put each note in the most relevant existing top-level folder, or create a new
  dedicated top-level folder for a new topic (e.g. `Agentic Workflow/`). Do not dump
  notes loose in the vault root.
- Existing top-level folders include: AI Assistant, Cybersecurity, Pi, Clippings,
  Miscellaneous, Agentic Workflow. (And the private `Personal` - off-limits.)
- One concern per note; split large topics into linked notes rather than one giant
  file. Be detailed but not repetitive - link with `[[wikilinks]]` instead of repeating.

## Naming
- Title Case, spaces allowed, `.md` extension (e.g. `Setup & Architecture.md`).
- Descriptive titles; the filename is the note title in Obsidian.

## Formatting (Obsidian-flavored markdown available here)
- **Frontmatter / properties** (start every note with it):
  ```
  ---
  tags: [topic, subtopic]
  created: YYYY-MM-DD
  ---
  ```
- **Links:** `[[Note Title]]`, aliased `[[Note Title|shown text]]`, embed `![[Note]]`
  or `![[image.png]]`. Cross-link liberally.
- **Callouts:** `> [!note]`, `> [!tip]`, `> [!warning]`, `> [!info]`, `> [!todo]`.
- **Tags:** `#tag`, nested `#area/sub`. Reuse the existing vocabulary where it fits
  (security notes use tags like `#SIEM`, `#CVE`, `#APT`, `#PII`, `#ISO`, `#AV`).
- **Tasks** (Tasks plugin): `- [ ] thing` with optional `📅 YYYY-MM-DD` due dates.
- **Tables** (table-editor), fenced code blocks, **Mermaid** diagrams (` ```mermaid `),
  and **Dataview** queries (` ```dataview `) are supported - use the last two sparingly,
  only when they genuinely help.
- Excalidraw drawings and mind-maps exist but are GUI-authored; write plain markdown,
  never fabricate `.excalidraw` files.
- **Plain ASCII dashes only** - no em-dash or en-dash, no decorative unicode.

## Git / committing
- The vault has **obsidian-git autocommit** enabled. Just write the files; new and
  edited notes are committed automatically. Do not `git commit`/`push` the vault
  manually unless asked.
