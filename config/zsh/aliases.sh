#!/usr/bin/env sh
# vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :

# nix aliases{{{
alias nxi="nix-env -iA"
alias nxu="nix-env -e"
alias nxs="nix-shell -iA"
alias nxp="nixops "

alias mp="mptcpanalyzer"
alias mn="mptcpnumerics"
# autres players a tester eventuellement
alias n="ncmpcpp"
# alias ff="find . -iname" # use fd instead
alias latest="ls -lt |head"

# alias :q="exit"
#}}}

### Dictionary lookup {{{
# local commands
alias lfren="dict -d fd-fra-eng "
alias lenfr="dict -d fd-eng-fra "

# for now require an internet access
alias fren="trans :en "
alias enfr="trans :fr "
# }}}

### Git {{{
# alias ga="git add"
# alias gl="git log"
# alias gst="git status"
# alias gs="git status"
# alias gd="git diff"
# alias gc="git commit"
# alias gcm="git commit -m"
# alias gca="git commit -a"
# alias gb="git branch"
# alias gbl="git branch --list" # todo add all ?
# alias gch="git checkout"
# alias gra="git remote add"
# alias grr="git remote rm"
# alias grv="git remote -v"
# alias gpu="git pull"
# alias gcl="git clone"
# alias gta="git tag -a -m"
# alias gf="git reflog"
alias gbr="git branch"
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
alias m="mutt -F \"\$XDG_CONFIG_HOME/mutt/muttrc\""
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


### compilation related {{{
alias makej="make -j4"
alias nm="nm -l"
# }}}

# Mail {{{
# alias ml="nix-shell -p python2.7  -n ~/.config/notmuch/notmuchrc_pro"
alias mg="python2.7 -malot -n ~/.config/notmuch/notmuchrc"
alias mg="nix-shell -p 'python.withPackages(ps: with ps; [ alot ])' --show-trace --run \"alot -n \$XDG_CONFIG_HOME/notmuch/notmuchrc\""
alias astroperso="astroid"
alias astropro="astroid -c ~/.config/astroid/config_pro"
# }}}
