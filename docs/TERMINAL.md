# Terminal tools guide (the Ship)

Everything interactive is themed Dracula (matching the mac host): WezTerm > tmux > bash (ble.sh) >
starship, plus bat / delta / fzf / eza / btop. This is the "how do I actually use
it" reference. tmux keys have their own doc: `docs/KEYBINDS.md` and the
interactive `docs/tmux-cheatsheet.html`.

## Reading the prompt (starship)

One line, mac-style: context modules then the prompt char, left to right.

- `~/dotfiles` (purple) - current dir, truncated to 3 segments
- `master` (pink) - git branch; only in repos
- git status (yellow, terse): `!` modified `?` untracked `+` staged `✘` deleted
  `»` renamed `$` stashed `=` conflicted `⇡2` ahead `⇣1` behind
- `py3.14` / `node22` (cyan) - language versions, only when relevant files present
- `3s` (comment grey) - last command duration, only if it took over 0.5s
- `✗ 1` (red) - last exit code, only when non-zero
- `❯` cyan = ready; red = previous command failed

## Typing (ble.sh)

The command line colors itself as you type:

- cyan = valid command - red = command not found / syntax error (before Enter!)
- yellow = quoted string - purple = options, variables, globs - grey = comments
- Grey ghost text after the cursor = autosuggestion from history.
  Accept it with Right arrow (or Ctrl+F at end of line). Keep typing to ignore.
- Tab opens a completion menu with descriptions; keep hitting Tab to cycle.
- Kill switch: comment the two ble.sh lines in `~/.bashrc` (top + bottom).

## Fuzzy everything (fzf)

- Ctrl+R - fuzzy search shell history. Type any fragment, Enter to run.
- Ctrl+T - fuzzy-pick file(s), path inserted at the cursor.
- Alt+C  - fuzzy-pick a directory and cd into it.
- Inside fzf: type to filter, arrows to move, Enter to accept, Esc to cancel.

## Jumping around (zoxide)

`z <fragment>` jumps to the most-used directory matching it (`z dot` ->
~/dotfiles). `zi` opens the candidate list in fzf. It learns from every cd.

## Listing files (eza aliases)

`ls` short - `ll` long+git - `la` long incl. hidden - `lt` by modified time -
`lk` by size - `lr` tree (3 levels) - `lf` files only - `ldir` dirs only

## Viewing files (bat)

`cat file` is bat: syntax-highlighted, Dracula, no pager (drop-in cat).
`bat file` adds line numbers, grid, and paging. Raw original: `\cat`.

## Git diffs (delta)

`git diff` / `git show` / `git log -p` page through delta: syntax-highlighted,
line numbers, Dracula. Inside: `n` / `N` jump between files, `q` quits.
Side-by-side once: `git -c delta.side-by-side=true diff`.

## Quality of life

- `extract <archive>` - unpacks tar/zip/7z/rar/anything.
- `tldr <cmd>` - example-first help (`tldr tar`), instant, offline cache.
- `man` pages are colored (headings cyan, options purple).
- `update` - `sudo dnf upgrade --refresh`.
- Git shorthand: `gs` status - `gl` graph log - `ga` add . - `gc` commit -
  `gco` checkout - `gp` push.

## Terminal chrome

- New WezTerm windows auto-attach the `main` tmux session (agent shells and
  tiny embedded terminals are excluded).
- WezTerm tab bar is off: tmux owns tabs/windows (prefix `C-a`, `f` sessionizer,
  `g` session picker, F12 remote passthrough - see KEYBINDS.md).
- Ctrl+Shift+B toggles the frosted-glass translucency. Ctrl+Shift+P opens the
  WezTerm command palette.

## Maintenance

- Reproduce this stack on a fresh machine: `install/terminal-color.sh`.
- Stow packages involved: `bash starship blesh bat git btop wezterm tmux`.
- Active theme: Dracula built-ins (bat/btop/vivid) + .blerc faces; fzf/less
  colors live in `bash/.bashrc.d/tools.sh`. The rose-pine theme files remain
  in-repo for easy switch-back.
