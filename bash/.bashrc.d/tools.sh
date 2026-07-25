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

# ---------------------------------------------------------------- color (rose-pine moon)
# fzf: official rose-pine/fzf moon palette (Ctrl+R history, Ctrl+T files, Alt+C cd,
# and the tmux sessionizer popup all inherit this).
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#232136,hl:#ea9a97
  --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
  --color=border:#44415a,header:#3e8fb0,gutter:#232136
  --color=spinner:#f6c177,info:#9ccfd8
  --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"
# fzf keybindings for plain-readline shells; under ble.sh the .blerc integration
# provides them instead (sourcing this one there would break the line editor).
if [[ ! ${BLE_VERSION-} ]] && [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
  source /usr/share/fzf/shell/key-bindings.bash
fi

# LS_COLORS: vivid's built-in rose-pine-moon theme colors ls/eza/completion listings.
command -v vivid >/dev/null && export LS_COLORS="$(vivid generate rose-pine-moon)"

# man pages: rose-pine colors via less termcaps (bold=foam, standout=gold on overlay,
# underline=iris). Same effect as omz colored-man-pages on the mac.
export LESS_TERMCAP_md=$'\e[1;38;2;156;207;216m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[38;2;246;193;119;48;2;57;53;82m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;38;2;196;167;231m'
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
