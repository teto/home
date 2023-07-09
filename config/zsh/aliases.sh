# vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
# TODO move to home-manager ?

function rfw(){
    readlink -f $(which "$1")
}


# to edit nixos kernel config
# then type $ make menuconfig
# make menuconfig KCONFIG_CONFIG=config_off
# try xconfig
# see https://nixos.wiki/wiki/Linux_Kernel for xconfig example

alias nvim-dev="nix develop --override-input nixpkgs /home/teto/nixpkgs --no-write-lock-file ./contrib#neovim-developer  --show-trace"
# alias notif-center='kill -s USR1 $(pidof deadd-notification-center)'
# --option extra-sandbox-paths "/bin/sh=$(readlink -f $(which bash))"
alias local-rebuild="nixos-rebuild --flake ~/home --override-input nixpkgs-teto /home/teto/nixpkgs --override-input hm /home/teto/hm --override-input nova /home/teto/nova/doctor --override-input mptcp-flake /home/teto/mptcp/mptcp-flake --no-write-lock-file switch --show-trace --use-remote-sudo"

# Gitops quick
alias mg='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && make gitops'
# TODO check return type in bw unlock --check 
alias bn='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && nix develop'
alias bnr='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && nix develop --option builders "$NOVA_OVH1"'
alias nfs='nix flake show'

# https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
# -f channel:nixos-unstable'
# github:nixos/nixpkgs/ff9efb0724de5ae0f9db9df2debefced7eb1571d
# alias hsenv='nix shell nixpkgs#ghc nixpkgs#haskell.packages.ghc8107.cabal-install nixpkgs#pkg-config nixpkgs#haskell-language-server'

# fzf-diff (https://medium.com/@GroundControl/better-git-diffs-with-fzf-89083739a9cb)
function fzd {
  preview="git diff $@ --color=always -- {-1}"
  git diff --name-only $@ | fzf -m --ansi --preview "$preview"
}

# to run
function nvimdev {
    folder="$1"
    shift
    binary="$folder/build/bin/nvim"
    if [ ! -f "$binary" ]; then
        echo "No binary $binary"
        return
    fi
    VIMRUNTIME="$folder/runtime" "$binary" "$@"

}

# git aliases
alias gap="git add -p";
alias grc="git rebase --continue";
alias gra="git rebase --abort";

# rename mptcp ?
alias mp="mptcpanalyzer"

# nix aliases {{{

# no
alias nixos-fast="nixos-rebuild --no-build-nix --fast"


# autres players a tester eventuellement
# alias n="ncmpcpp"
function n {
    if [ -f "./contrib/flake.nix" ];
    then 
        nix develop ./contrib
    else 
        nix develop "$@"
    fi
}
alias n="nix develop"
# alias nb='nix develop--option builders "$RUNNER3" -j0'
alias n1='nix develop --option builders "$NOVA_RUNNER1" -j0'
alias n2='nix develop --option builders "$NOVA_RUNNER2" -j0'
alias n3='nix develop --option builders "$NOVA_RUNNER3" -j0'
# TODO should use all runners
alias nall='nix develop --option builders "$NOVA_RUNNER3" -j0'
alias nr="nix run "
alias nr3='nix run --option builders "$NOVA_RUNNER3" -j0'
alias nl="nix log "
# alias lens="sudo rm -rf /home/teto/.config/Lens/extensions && lens"
# alias ff="find . -iname" # use fd instead
function latest {
    # shellcheck disable=SC2012
    ls -lt "$@" |head
}

#}}}

# alias servethis="nix run nixpkgs#python3 --command \'python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'\""

# ls related updates {{{
# I also export TIME_STYLE to change the output of this
alias ls="ls --color=auto --time-style=iso"
alias ll="ls -l"
alias la="ls -la"
# -r makes recent changes appear last, more practical
# alias llt="ls -ltr"
# }}}

# oftenly used programs {{{
# alias c="cat"
# alias v="nvim"
#alias n="nvim"
alias m="neomutt -F \"\$XDG_CONFIG_HOME/mutt/muttrc\""
# view uses vim as a pager
alias l="nvim +view"
alias s="sxiv"
# parce que apvlv est plus libre que zathura
alias z="apvlv"
alias q="qutebrowser"
# }}}

# compilation related {{{
alias makej="make -j4"
alias nm="nm -l"
# }}}
