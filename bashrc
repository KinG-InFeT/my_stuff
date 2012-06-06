#Inizializzazione rxvt
echo "loading..."
sleep 1
clear
cowsay -f tux 'Welcome to urxvt on KinG-InFeT PC'
echo "Kernel:"
uname -r

#export variable env
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"

PS1="\[\033[01;31m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "
#PS1="┌─[\[\e[0;35m\]\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]]\n└─╼ "

alias sprunger="curl -F 'sprunge=<-' http://sprunge.us"
alias moc=mocp

alias grep="grep --color=auto"
alias ls="ls --color=auto"

alias reboot="shutdown -r now"
alias shut="shutdown -h now"

alias pacman="pacman-color"

# Usage: extract <nome_file>
# Estrazione di diversi pacchetti di archiviazione
function extract() {
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
function wmip() { 
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

function chmod_htdocs {

    echo "chmod -> /opt/lampp/htdocs/"
    echo "loading..."
    
    sleep 1

    chmod -R 777 /opt/lampp/htdocs/
    echo "Complete!"
}

function screen {
    
    echo "Screen.."

    scrot -cd 3 tmp.png
    
    echo "Uploading image..."
    
    imageupload tmp.png
    
    echo "Deleting image..."
    
    rm tmp.png
    
    echo "Done."
}

function clear_system() {

    echo "Clear tmp and log file..."
    
    #echo "" > /var/log/user.log
    #echo "" > /var/log/syslog
    #echo "" > /var/log/debug
    #echo "" > /var/log/emesene
    #echo "" > /var/log/emerge-fetch.log
    
    #echo "Clear /usr/portage/distfiles ..."
    
    #rm -fr /usr/portage/distfiles/*
    
    echo "Clear COMPLETE!!";

}
