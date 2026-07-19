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
