# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# ~/.zshrc - Zsh configuration

# ────────────────────────────────────────────────
# 🧠 SHELL OPTIONS
# ────────────────────────────────────────────────
setopt autocd              # `cd folder` → just type folder name
setopt correct             # autocorrect minor typos
setopt interactivecomments # allow comments in interactive shell
setopt histignoredups      # ignore duplicate commands in history
setopt extendedglob        # extended pattern matching
setopt notify              # notify when background jobs complete

# ────────────────────────────────────────────────
# 🧩 OH-MY-ZSH
# ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""   # prompt handled by Starship (see eval below); p10k kept dormant for rollback

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  colored-man-pages
  sudo
  macos
)

source $ZSH/oh-my-zsh.sh

# ────────────────────────────────────────────────
# 🚀 STARSHIP PROMPT (Dracula — matches WezTerm)
# ────────────────────────────────────────────────
eval "$(starship init zsh)"

# ────────────────────────────────────────────────
# 🎨 DRACULA SYNTAX HIGHLIGHTING (no green on typed text)
#    cyan = commands/tooling · pink = operators · yellow = strings
#    purple = options/globs · red = errors · comment = comments
# ────────────────────────────────────────────────
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#f8f8f2'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff5555,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[function]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[command]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#8be9fd,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#8be9fd'
ZSH_HIGHLIGHT_STYLES[path]='fg=#f8f8f2,underline'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#bd93f9,italic'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#bd93f9'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bd93f9'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#bd93f9'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#bd93f9'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f1fa8c'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f1fa8c'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f1fa8c'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272a4'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#f8f8f2'
# autosuggestion ghost text -> Dracula comment grey
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6272a4'

# ────────────────────────────────────────────────
# 📁 PATH MANAGEMENT
# ────────────────────────────────────────────────
export PATH="/opt/homebrew/bin:$HOME/.local/bin:$PATH"

# ────────────────────────────────────────────────
# 🔗 AUTO-ATTACH TMUX (persistent sessions, WezTerm only)
#    Skips VS Code, Claude Code, scripts, and nested tmux.
# ────────────────────────────────────────────────
if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" == "WezTerm" ]] && command -v tmux &>/dev/null; then
  tmux attach -t main 2>/dev/null || tmux new -s main
fi

# ────────────────────────────────────────────────
# 🛠️ ALIASES
# ────────────────────────────────────────────────
# eza (modern ls) — dirs first, no icons
alias ls="eza --group-directories-first"
alias ll="eza -lh --group-directories-first --git"
alias la="eza -lha --group-directories-first --git"
alias lt="eza --tree --level=2 --group-directories-first"
# bat (modern cat) — Catppuccin Mocha theme, behaves like cat
alias cat="bat --style=plain --paging=never"
export BAT_THEME="Dracula"
alias ..="cd .."
alias ...="cd ../.."
alias grep="grep --color=auto"
alias update="brew update && brew upgrade && brew cleanup"

# Projects & shortcuts
alias nvimconfig="nvim ~/.config/nvim"
alias zshconfig="nvim ~/.zshrc"
alias p10kconfig="nvim ~/.p10k.zsh"
alias smbshare="cd /Volumes/share"

# Git
alias gs="git status"
alias gc="git commit"
alias gl="git log --oneline --graph"
alias gco="git checkout"
alias gp="git push"
alias ga="git add ."

# Security tools
alias nmapscan="nmap -T4 -A -v"

# AWS profile aliases + other work/machine-specific config live in
# ~/.zshrc.local (gitignored — kept out of the public dotfiles repo).

# Misc. 
alias ip="ipconfig getifaddr en0"
alias public="curl ifconfig.me"
alias vi="nvim"
alias vim="nvim"
alias cc="claude --dangerously-skip-permissions"
# ────────────────────────────────────────────────
# 🔁 FUNCTIONS
# ────────────────────────────────────────────────
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ────────────────────────────────────────────────
# 📜 HISTORY
# ────────────────────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# ────────────────────────────────────────────────
# 🎨 PROMPT + DISPLAY
# ────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

# Disable Ctrl+S freeze
stty -ixon

# ────────────────────────────────────────────────
# ⛅ STARTUP MESSAGE
# ────────────────────────────────────────────────
echo "Welcome, Barrett 👋 — $(date +'%A, %B %d %Y')"


eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Add Homebrew to PATH
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Added by Antigravity
export PATH="/Users/user/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/user/.bun/_bun" ] && source "/Users/user/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# auto complte  
bindkey '\t' autosuggest-accept

# opencode
export PATH=/Users/user/.opencode/bin:$PATH

# Machine/work-specific overrides (gitignored; holds AWS profiles, work paths, etc.)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
