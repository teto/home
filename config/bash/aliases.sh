# shellcheck shell=bash
alias pc="process-compose"
alias n="nix develop"
alias nb='nix build'
alias nb1='nix build --option builders "$NOVA_OVH1" -j0'
alias n1='nix develop --option builders "$NOVA_OVH1" -j0'
alias n2='nix develop --option builders "$NOVA_CAMPUS1" -j0'
# alias n3='nix develop --option builders "$NOVA_CAMPUS2" -j0'

# Haskell related aliases{{{
alias nhs98="nix develop \$HOME/home#nhs98"
alias nhs910="nix develop \$HOME/home#nhs910"
alias nhs912="nix develop \$HOME/home#nhs912"
# }}}

# TODO should use all runners
# alias nall='nix develop --option builders "$NOVA_OVH1" -j0'
alias nr="nix run "
alias nr1='nix run --option builders "$NOVA_OVH1" -j0'
alias nr2='nix run --option builders "$NOVA_CAMPUS1" -j0'
alias nl="nix log "
alias g="git"
alias y=yazi
alias j="just -g"
alias js="just switch"
alias jr="just build"
alias jctl="journalctl -b0"

# git aliases
alias gap="git add -p"
alias grc="git rebase --continue"
alias gra="git rebase --abort"

# rename mptcp ?
# alias mp="mptcpanalyzer"

# nix aliases {{{

# directories only
alias ld="eza -lD"
# alias      lf="eza -lF --color=always | grep -v /";
alias lh="eza -dl .* --group-directories-first"
# alias      ll="eza -al --group-directories-first";
# alias      lt="eza -al --sort=modified -snew";

# advanced
# TODO add --hyperlink
alias ls='eza --color=always --group-directories-first --icons=auto --hyperlink'
alias ll='eza -la --icons --octal-permissions --group-directories-first --hyperlink'
# alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons=auto'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons=auto'

alias lS='eza -1 --color=always --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons=auto -snew'
# alias l.="eza -a | grep -E '^\.'"

# ls related updates {{{
# I also export TIME_STYLE to change the output of this
# alias ls="ls --hyperlink=auto -p --color=auto --time-style=iso"
# alias ll="ls -l"
# alias la="ls -la"
# -r makes recent changes appear last, more practical
# alias llt="ls -ltr"
# }}}

# oftenly used programs {{{
# alias c="cat"
# alias v="nvim"
#alias n="nvim"
# TODO alias to meli
alias m="neomutt -F \"\$XDG_CONFIG_HOME/mutt/muttrc\""
# view uses vim as a pager
alias l="nvim +view"
alias s="sxiv"
# parce que apvlv est plus libre que zathura
# alias z="apvlv"
alias q="qutebrowser"
# }}}

# compilation related {{{
alias makej="make -j4"
alias nm="nm -l"
# }}}

export MCFLY_KEY_SCHEME=vim

# defaults to 'RANK'
export MCFLY_RESULTS_SORT=LAST_RUN
export MCFLY_RESULTS=200
# export MCFLY_INTERFACE_VIEW=BOTTOM
# MCFLY_DISABLE_MENU
# export MCFLY_PROMPT="❯"
# export MCFLY_HISTORY_LIMIT

# show branch
# alias gv=glab ci view -b "\$(jj log -r 'ancestors(@) & bookmarks()')"

