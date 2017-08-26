#  vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker : 
# Suffix aliases execute a command based on a file’s extension. Suffix aliases are used with the alias -s command.  Here’s my favorite feature of aliases in zsh.  By adding this line:
# g => global , does not depend on position on line
# todo find a better option relying on xdg-open etc...
alias -s html=qutebrowser
alias -s json=nvim
alias -s Vagrantfile=nvim
alias -s py=python3
alias -s rb=ruby
alias -s png=sxiv
alias -s jpg=xdg-open
alias -s gif=xdg-open
alias -s avi=mpv
alias -s mp3=mocp
alias -s pdf=xdg-open
alias -s doc=xdg-open
alias -s docx=xdg-open


alias mp="mptcpanalyzer"
alias mn="mptcpnumerics"
# autres players a tester eventuellement
alias n="ncmpcpp"
alias ff="find . -iname"
# alias size="du -h --max-depth=1"
alias latest="ls -lt |head"


alias :q="exit"


### Dictionary lookup {{{
# local commands
alias lfren="dict -d fd-fra-eng "
alias lenfr="dict -d fd-eng-fra "

# for now require an internet access
alias fren="trans :en "
alias enfr="trans :fr "
# }}}


### Git {{{
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gst="git status"
alias gs='git status'
alias gd='git diff'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
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
alias gbr='git branch'
# }}}


# not always needed ?
# alias rake="rake1.9.1"
##############################
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
alias shellpath='python -c "import sys; print sys.env.PATH" | tr "," "\n" | grep -v "egg"'
alias set_time="dpkg-reconfigure tzdata"

### ls related updates {{{
# I also export TIME_STYLE to change the output of this
alias ls="ls --color=auto --time-style=iso"
alias ll="ls -l" 
alias la="ls -a"
alias lla="ls -la"
# -r makes recent changes appear last, more practical
alias llt="ls -ltr"
# }}}

# oftenly used programs {{{
alias c="cat"
alias v="nvim"
#alias n="nvim"
alias m="mutt -F \"$XDG_CONFIG_HOME/mutt/muttrc\""
alias r="ranger"
# view uses vim as a pager
alias l="nvim +view"
alias s="sxiv" 
# parce que apvlv est plus libre que zathura
alias z="apvlv"
alias q="qutebrowser"
# }}}

# Movement aliases {{{
alias ..="cd .."
alias ...="cd ../.."
#}}}

# vagrant {{{
alias -g vinit="vagrant init"
alias -g vup="vagrant up"
alias -g vssh="vagrant ssh"
alias -g vhalt="vagrant halt"
alias -g vpi="vagrant plugin install"
alias -g vpu="vagrant plugin uninstall"
alias -g vpl="vagrant plugin list"
# }}}

### package managmeent related {{{
alias -g agi="sudo apt install"
alias -g agr="sudo apt remove"
alias -g agy="sudo apt -y install"
alias -g acl="apt-cache search"
alias -g acf="apt-cache find"
alias -g acs="apt-cache show"
alias -g agu="sudo apt update "
alias -g agg="sudo apt update && sudo apt upgrade"
alias -g agf="sudo apt update && sudo apt full-upgrade"
# }}}

alias sdpkg="sudo dpkg"

### 
alias dfh="df --human-readable"
alias duh="du --human-readable"


# todo add option to discard ENV ?!
alias sv="sudo nvim"
# vim
alias ec='nvim $XDG_CONFIG_HOME/'

# python related {{{
alias pipu='python3.5 -mpip install -U --user '
alias pydev='python3.5 setup.py develop --user'
# }}}

# Gestion du 'ls' : couleur & ne touche pas aux accents
alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'

# if [ -x /usr/bin/dircolors ]; then
# #    eval "`dircolors -b`"
#     alias dir='dir --color=auto'
#     alias vdir='vdir --color=auto'

#     alias grep='grep --color=auto'
#     alias fgrep='fgrep --color=auto'
#     alias egrep='egrep --color=auto'
# fi

### compilation related {{{
alias makej="make -j4"
alias nm="nm -l"
# }}}

# Mail {{{
alias ml="python2.7 -malot -n ~/.config/notmuch/notmuchrc_pro"
alias mg="python2.7 -malot -n ~/.config/notmuch/notmuchrc"
alias astroperso="astroid"
alias astropro="astroid -c ~/.config/astroid/config_pro"
# }}}
