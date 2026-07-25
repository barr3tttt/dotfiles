# Shell tool initialization (tracked in dotfiles).

# Splash on interactive shells only (login scripts skip it)
if [[ $- == *i* ]] && command -v fastfetch >/dev/null; then
  fastfetch
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
command -v zoxide >/dev/null && eval "$(zoxide init bash)"
command -v starship >/dev/null && eval "$(starship init bash)"

# voice-dictate / ydotool
export YDOTOOL_SOCKET="/run/ydotoold.socket"

# ---------------------------------------------------------------- color (Dracula)
# fzf: official dracula/fzf palette (Ctrl+R history, Ctrl+T files, Alt+C cd,
# and the tmux sessionizer popup all inherit this).
export FZF_DEFAULT_OPTS="
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=border:#44475a,header:#6272a4,gutter:#282a36
  --color=spinner:#ffb86c,info:#ffb86c
  --color=pointer:#ff79c6,marker:#ff79c6,prompt:#50fa7b"
# fzf keybindings for plain-readline shells; under ble.sh the .blerc integration
# provides them instead (sourcing this one there would break the line editor).
if [[ ! ${BLE_VERSION-} ]] && [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi

# LS_COLORS: vivid's built-in dracula theme colors ls/eza/completion listings.
command -v vivid >/dev/null && export LS_COLORS="$(vivid generate dracula)"

# man pages: Dracula colors via less termcaps (bold=cyan, standout=yellow on
# selection, underline=purple). Same effect as omz colored-man-pages on the mac.
export LESS_TERMCAP_md=$'\e[1;38;2;139;233;253m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[38;2;241;250;140;48;2;68;71;90m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;38;2;189;147;249m'
export LESS_TERMCAP_ue=$'\e[0m'
export GROFF_NO_SGR=1   # groff emits classic termcaps so the colors above apply

# ---------------------------------------------------------------- tmux auto-attach
# New WezTerm windows land in the persistent 'main' tmux session (mac parity).
# Guards: interactive, not nested, not a Claude/agent shell, real-sized pty.
if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -z "$CLAUDECODE" ]] \
   && [[ "$TERM_PROGRAM" == "WezTerm" ]] && command -v tmux >/dev/null \
   && [[ "$(tput lines 2>/dev/null || echo 0)" -ge 10 ]]; then
  tmux attach -t main 2>/dev/null || tmux new -s main
fi
