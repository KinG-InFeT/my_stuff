# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#export PATH=$PATH:/opt/node-v8.9.4-linux-x64/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#export PATH="$HOME/.rbenv/bin:$PATH"

#eval "$(rbenv init -)"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"

# NUOVE VARIABILI DI AMBIENTE
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ORG_GRADLE_PROJECT_cdvMinSdkVersion=20

JAVA_HOME=/usr/local/java/jdk1.8.0_191
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export JAVA_HOME
export PATH

nvm use 10 --silent
ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}

#Inizializzazione rxvt
cowsay -f tux 'Welcome Vincenzo Luongo'
lsb_release -a
echo ""

alias home='cd $home'
alias h='history'
alias lss='ls -al --color=auto'
alias psg='ps -aux | grep'
alias ps='ps -aux'
alias sprunger="curl -F 'sprunge=<-' http://sprunge.us"
alias moc="mocp ~/Musica"
alias vi=vim
alias tail="tail -lf"
alias grep="grep --color=auto"

alias reboot="shutdown -r now"
alias shut="shutdown -h now"

export HISTTIMEFORMAT="%d/%m/%y %T "

#export variable env per colori LS
#export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"

#Caratteri speciali Bash
MYL1="\033(0l\033(B"
MYL2="\033(0mq\033(B"
MYL3="\033(0q\033(B"

#colori Bash
BLACK="\[\033[0;30m\]"
DGRAY="\[\033[1;30m\]"
BLUE="\[\033[0;34m\]"
LBLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LGREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LCYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LRED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LPURPLE="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
LGRAY="\[\033[0;37m\]"
WHITE="\[\033[1;37m\]"
NONE="\[\033[0m\]"

#PS1="$RED$MYL1$MYL3[$WHITE\u$RED]$WHITE @ $RED[$WHITE\h$RED]
#$MYL2$RED[$WHITE(\w)$RED] > $NONE"
PS1='\[\033[0;31m\]\[\033[0m\033[0;31m\]\u\[\033[0;31m\] @ \[\033[0;36m\]\h - [\[\033[0;32m\]$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;31m\]\[\033[0;36m\]]\n\w\[\033[0;31m\]\n\[\033[0;31m\]└─\[\033[0m\033[0;31m\] \$\[\033[0m\033[0;31m\] ▶ \[\033[0m\] '

# Usage: estrai <nome_file>
# Estrazione di diversi pacchetti di archiviazione
function estrai() {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}

#Stampare il proprio IP esterno
function myip() { 
    wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
}

#Usage: imageupload <image_file_name>
#Upload an image on imgur.com
function imageupload {
    curl -s -F "image=@$1" -F "key=486690f872c678126a2c09a9e196ce1b" http://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
}

# Usage: sprunge <file>
# Upload the file's content on sprunge.us (PERMANENT)
function sprunge {
    cat $1 | sprunger
}

# Usage: tmPaste <file>
# Upload the file's content on theworm.tx (30 Days validate)
function tmpaste() {
    cat $1 | curl -s -F 'code=<-' paste.theworm.tw
}
