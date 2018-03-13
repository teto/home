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
# alias lfren="dict -d fd-fra-eng "
# alias lenfr="dict -d fd-eng-fra "

# for now require an internet access
# alias fren="trans -from fr -to en "
# alias enfr="trans -from en -to fr "
# alias jpfr="trans -from jp -to fr "
# alias frjp="trans -from jp -to fr "
# alias jpen="trans -from jp -to en "
# alias enjp="trans -from en -to jp "
# }}}



# not always needed ?
# alias rake="rake1.9.1"
##############################
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"
# alias pypath='python -c "import sys; print sys.path" | tr "," "\n" | grep -v "egg"'
# alias shellpath='python -c "import sys; print sys.env.PATH" | tr "," "\n" | grep -v "egg"'


# ls related updates {{{
# I also export TIME_STYLE to change the output of this
alias ls="ls --color=auto --time-style=iso"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
# -r makes recent changes appear last, more practical
alias llt="ls -ltr"
# }}}

# oftenly used programs {{{
# alias c="cat"
# alias v="nvim"
#alias n="nvim"
alias m="mutt -F \"\$XDG_CONFIG_HOME/mutt/muttrc\""
# alias r="ranger"
# view uses vim as a pager
alias l="nvim +view"
alias s="sxiv"
# parce que apvlv est plus libre que zathura
alias z="apvlv"
alias q="qutebrowser"
# }}}

### compilation related {{{
alias makej="make -j4"
alias nm="nm -l"
# }}}

# Mail {{{
# alias ml="nix-shell -p python2.7  -n ~/.config/notmuch/notmuchrc_pro"
alias mg="alot -n $XDG_CONFIG_HOME/notmuchrc"
alias mg="nix-shell -p 'python.withPackages(ps: with ps; [ alot ])' --show-trace --run \"alot -n \$XDG_CONFIG_HOME/notmuch/notmuchrc\""
# alias astroperso="astroid"
# alias astropro="astroid -c ~/.config/astroid/config_pro"
# }}}
