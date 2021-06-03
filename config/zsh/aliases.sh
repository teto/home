# vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
# TODO move to home-manager ?


# to edit nixos kernel config
# then type $ make menuconfig
# make menuconfig KCONFIG_CONFIG=config_off
# try xconfig
# see https://nixos.wiki/wiki/Linux_Kernel for xconfig example

alias nvim-dev="nix develop --override-input nixpkgs /home/teto/nixpkgs --no-write-lock-file ./contrib#neovim-developer  --show-trace"
alias notif-center="kill -s USR1 $(pidof deadd-notification-center)"
# --option extra-sandbox-paths "/bin/sh=$(readlink -f $(which bash))"
alias local-rebuild="sudo nixos-rebuild --flake ~/home --override-input nixpkgs-teto /home/teto/nixpkgs --override-input hm /home/teto/hm --override-input nova /home/teto/nova/nova-nix --override-input mptcp-flake /home/teto/mptcp/mptcp-flake --no-write-lock-file switch --show-trace"
# TODO
# export BW_SESSION=$(bw unlock --raw)

# Gitops quick
alias mg='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && make gitops'

# nix aliases {{{

# no
alias nixos-fast="nixos-rebuild  --no-build-nix --fast"


# rename mptcp ?
alias mp="mptcpanalyzer"

# autres players a tester eventuellement
# alias n="ncmpcpp"
alias n="nix develop"
alias ns="nix-shell"
# alias lens="sudo rm -rf /home/teto/.config/Lens/extensions && lens"
# alias ff="find . -iname" # use fd instead
alias latest="ls -lt $@ |head"

alias :q="exit"
#}}}

function rfw(){
    readlink -f $(which "$1")
}

alias servethis="nix-shell -ppython3 --command \'python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'\""

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
