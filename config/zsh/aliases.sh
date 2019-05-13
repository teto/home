# vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
# TODO move to home-manager ?


# to edit nixos kernel config
# then type $ make menuconfig
# make menuconfig KCONFIG_CONFIG=config_off
# try xconfig
# see https://nixos.wiki/wiki/Linux_Kernel for xconfig example
alias kernel_makeconfig="nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command 'make menuconfig KCONFIG_CONFIG=build/.config"
alias kernel_xconfig="nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})'"
alias kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"

# nix aliases {{{

# no
alias nixos-fast="nixos-rebuild  --no-build-nix --fast"

# todo fix completion accordingly
alias nxi="nix-env -iA"
alias nxu="nix-env -e"
alias nxs="nix-shell"
alias nxp="nixops "

# rename mptcp ?
alias mp="mptcpanalyzer"

# autres players a tester eventuellement
# alias n="ncmpcpp"
alias n="nix-shell"
# alias ff="find . -iname" # use fd instead
alias latest="ls -lt |head"

# alias :q="exit"
#}}}

function rfw(){
    readlink -f $(which "$1")
}

alias servethis="nix-shell -ppython3 --command \'python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'\""

alias testneovim=" nix-shell -E 'with import <nixpkgs> {}; neovim-unwrapped.overrideAttrs(oa: { doCheck=true;})'"

# todo use exa instead

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
