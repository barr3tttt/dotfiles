# Curated aliases (tracked in dotfiles). Machine-specific bits stay in ~/.bashrc.

# Safety nets
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'

# Editors
alias vi='nvim'
alias svi='sudo vi'
alias vis='nvim "+set si"'
alias ebrc='vi ~/.bashrc'

# Directory listing (powered by eza)
_eza_base='eza --icons --group-directories-first'
_eza_long="$_eza_base --git --long"
alias ls="$_eza_base"                       # basic listing
alias la="$_eza_long --all"                 # long, including hidden
alias ll="$_eza_long"                       # long listing
alias lla="$_eza_long --all"                # long, including hidden
alias lls="$_eza_long"                      # long listing
alias las='eza --icons --all'               # short, including hidden
alias labc="$_eza_long --all --sort=name"   # alphabetical
alias lt="$_eza_long --sort=modified"       # sort by modified time
alias lc="$_eza_long --sort=changed"        # sort by changed time
alias lu="$_eza_long --sort=accessed"       # sort by accessed time
alias lk="$_eza_long --sort=size --reverse" # sort by size
alias lx="$_eza_long --sort=extension"      # sort by extension
alias lr="$_eza_base --tree --level=3"      # tree view (3 levels)
alias lw="$_eza_base --oneline"             # one entry per line
alias lm="$_eza_long --all | less"          # page through long listing
alias lf="$_eza_long --only-files"          # files only
alias ldir="$_eza_long --only-dirs"         # directories only

# Navigation
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd "$OLDPWD"'

# Search
alias h="history | grep "
alias p="ps aux | grep "
alias f="find . | grep "
alias checkcommand="type -t"

# System info
alias top="btop"
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
alias ps='ps auxf'
alias openports='netstat -nape --inet'
alias mountedinfo='df -hT'
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"
alias da='date "+%Y-%m-%d %A %T %Z"'

# Network
alias myip='curl -s https://ipinfo.io/ip'
alias speed='sudo speedtest'
alias ping='ping -c 10'
alias cve="curl -s https://cvedb.shodan.io/cves | jq '.cves[] | {cve_id,summary,published_time}' | head -n 50"

# Permissions
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Git (mac parity)
alias gs='git status'
alias gc='git commit'
alias gl='git log --oneline --graph'
alias gco='git checkout'
alias gp='git push'
alias ga='git add .'

# Modern cat (bat; theme comes from ~/.config/bat/config). Real cat: \cat
alias cat='bat --style=plain --paging=never'

# System update (mac parity: brew update && upgrade && cleanup)
alias update='sudo dnf upgrade --refresh'

# Misc
alias less='less -R'
alias cls='clear'
alias rmd='/bin/rm --recursive --force --verbose '
alias sha1='openssl sha1'
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Agents
alias cc="claude --dangerously-skip-permissions"

# Docker
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '
