# ZSH specific
# Suffix aliases execute a command based on a file’s extension. Suffix aliases are used with the alias -s command.  Here’s my favorite feature of aliases in zsh.  By adding this line:
# g => global , does not depend on position on line
alias -s html=vim
alias -s json=vim
alias -s Vagrantfile=vim
alias -s rb=ruby
alias -s py=python3
alias -s png=eog
alias -s jpg=eog
alias -s gif=eog
alias -s avi=mplayer
alias -s mp3=mocp


##############################
### Dictionary lookup
##############################
alias dfren="dict -d fd-fra-eng"
alias denfr="dict -d fd-eng-fra"



##############################
### Git
##############################
alias ga='git add'
alias gaa='git add --all'
alias gp='git push'
alias gl='git log'
alias gst="git status"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gbl="git branch --list" # todo add all ?
alias gch='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias grv='git remote -v'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'




# not always needed ?
# alias rake="rake1.9.1"
##############################
# 
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'

##############################
### ls related updates
##############################
alias ls="ls --color=auto"
alias l="ls -l" 
alias ll="ls -l" 
alias la="ls -a"
alias lla="ls -la"
alias llt="ls -lt"

alias v="vim"
alias nv="nvim"

# Movement aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

##############################
### vagrant
##############################
alias -g vinit="vagrant init"
alias -g vup="vagrant up"
alias -g vssh="vagrant ssh"
alias -g vhalt="vagrant halt"
alias -g vpi="vagrant plugin install"
alias -g vpu="vagrant plugin uninstall"
alias -g vpl="vagrant plugin list"

##############################
### package managmeent related
##############################
alias agi="sudo apt install"
alias agr="sudo apt remove"
alias agy="sudo apt -y install"
alias acl="apt-cache search"
alias acf="apt-cache find"
alias acs="apt-cache show"
alias agg="sudo apt update && sudo apt upgrade"
alias agf="sudo apt update && sudo apt full-upgrade"

alias sdpkg="sudo dpkg"

### 
alias dfh="df --human-readable"
alias duh="du --human-readable"


alias sv="sudo vim"

# Gestion du 'ls' : couleur & ne touche pas aux accents
alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'

if [ -x /usr/bin/dircolors ]; then
#    eval "`dircolors -b`"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Demande confirmation avant d'écraser un fichier
#alias cp='cp --interactive'
#alias mv='mv --interactive'
#alias rm='rm --interactive'



##############################
### compilation related 
##############################
alias makej="make -j4"
