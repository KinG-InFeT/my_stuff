# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Welcome banner: the classic Tux, a quick system check and a random hacker quote.
# No network calls, so a new terminal still opens instantly.
welcome_banner() {
    # DarkRedHack palette: bold red, red, dim grey, white, green.
    local r=$'\e[1;38;2;255;0;39m' red=$'\e[0;38;2;255;0;39m' d=$'\e[0;38;2;92;95;104m' w=$'\e[0;38;2;230;232;236m'
    local g=$'\e[0;38;2;15;210;155m' n=$'\e[0m'
    local name os ip vpn=down i
    name=$(getent passwd "$USER" | cut -d: -f5 | cut -d, -f1)
    os=$(. /etc/os-release && echo "$PRETTY_NAME")
    ip=$(hostname -I 2>/dev/null | cut -d' ' -f1)
    [[ -n $(ip -br link show type wireguard 2>/dev/null)$(ip -br link show type tun 2>/dev/null) ]] && vpn=up
    local quotes=(
        "Hack the planet!"
        "The quieter you become, the more you are able to hear."
        "There is no patch for human stupidity."
        "There's no place like 127.0.0.1"
        "Never trust user input."
        "Security is a process, not a product. (Bruce Schneier)"
        "Talk is cheap. Show me the code. (Linus Torvalds)"
        "It's not a bug, it's an undocumented feature."
        "The only truly secure system is one that is powered off."
        "Mess with the best, die like the rest."
    )
    local tux=(
        $'        .--.'
        $'       |o_o |'
        $'       |:_/ |'
        $'      //   \\ \\'
        $'     (|     | )'
        $'    /\'\\_   _/`\\'
        $'    \\___)=(___/'
    )
    local info=(
        "${d}[${g} OK ${d}] identity ...${n} ${w}${name:-$USER}${d} ($USER@$HOSTNAME)${n}"
        "${d}[${g} OK ${d}] system .....${n} ${w}${os}${d} · kernel $(uname -r)${n}"
        "${d}[${g} OK ${d}] uptime .....${n} ${w}$(uptime -p | sed 's/^up //')${d} · load $(cut -d' ' -f1 /proc/loadavg)${n}"
        "${d}[${g} OK ${d}] network ....${n} ${w}${ip:-offline}${d} · vpn ${vpn}${n}"
        "${d}[${g} OK ${d}] session ....${n} ${w}$(tty | sed 's|^/dev/||')${d} · $(date '+%a %d %b %Y %H:%M')${n}"
        "${d}[${r} ** ${d}] status .....${n} ${r}ACCESS GRANTED${n}"
        ""
    )
    echo
    for i in "${!tux[@]}"; do
        printf '%s%-16s%s  %s\n' "$r" "${tux[i]}" "$n" "${info[i]}"
    done
    printf '  %s> %s%s\n\n' "$red" "${quotes[RANDOM % ${#quotes[@]}]}" "$n"
}
welcome_banner

export ANDROID_SDK_ROOT=/home/vluongo/Android/Sdk
export PATH=${PATH}:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:/opt/gradle/gradle-7.6/bin

#export ORG_GRADLE_PROJECT_cdvMinSdkVersion=20

#JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
JAVA_HOME=/usr/lib/jvm/jdk-23.0.2-oracle-x64
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export PATH

PS1='\[\033[0;31m\]\[\033[0m\033[0;31m\]\u\[\033[0;31m\] @ \[\033[0;36m\]\h - [\[\033[0;32m\]$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;31m\]\[\033[0;36m\]]\n\w\[\033[0;31m\]\n\[\033[0;31m\]└─\[\033[0m\033[0;31m\] \$\[\033[0m\033[0;31m\] ▶ \[\033[0m\] '

function myip() { 
    wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
}

alias python=python3
alias clauded="export MAX_MCP_OUTPUT_TOKENS=50000 && claude --dangerously-skip-permissions"
alias codexd="codex --dangerously-bypass-approvals-and-sandbox"