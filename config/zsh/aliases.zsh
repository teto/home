#  vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
#  zsh specific aliases only
#

# Suffix aliases execute a command based on a file’s extension. Suffix aliases are used with the alias -s command.  Here’s my favorite feature of aliases in zsh.  By adding this line:
# g => global , does not depend on position on line
# todo find a better option relying on xdg-open etc...
alias -s html=qutebrowser
alias -s json=nvim
alias -s Vagrantfile=nvim
alias -s png=sxiv
alias -s jpg=xdg-open
alias -s gif=xdg-open
alias -s avi=mpv
alias -s mp3=mocp
alias -s pdf=xdg-open
alias -s {doc,docx}=xdg-open
alias -s git="git clone"


alias dfh="df --human-readable"
alias duh="du --human-readable"
alias nd="nix develop"

alias weather="curl v2.wttr.in"

# alias preview="fzf --preview 'bat --color \"always\" {}'"
# alias notif-center='kill -s USR1 $(pidof deadd-notification-center)'

# Gestion du 'ls' : couleur & ne touche pas aux accents
# alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'
# vim: set et fenc=utf-8 ff=unix sts=0 sw=4 ts=4 fdm=marker :
# TODO move to home-manager ?

rfw(){
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
# alias local-rebuild="nixos-rebuild --flake ~/home --override-input nixpkgs-teto /home/teto/nixpkgs --override-input hm /home/teto/hm --override-input nova /home/teto/nova/doctor --override-input mptcp-flake /home/teto/mptcp/mptcp-flake --no-write-lock-file switch --show-trace --use-remote-sudo"

# Gitops quick
# TODO check return type in bw unlock --check 
# alias bn='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && nix develop'
# alias bnr='if [ -z ${BW_SESSION} ]; then export BW_SESSION=$(bw unlock --raw); fi && nix develop --option builders "$NOVA_OVH1"'
alias nfs='nix flake show'


# https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
# -f channel:nixos-unstable'

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
# alias lens="sudo rm -rf /home/teto/.config/Lens/extensions && lens"
# alias ff="find . -iname" # use fd instead
function latest {
    # shellcheck disable=SC2012
    eza --sort newest "$@"
}

#}}}
