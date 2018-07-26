{ pkgs, ... }:
with pkgs; [
     automake
     autoconf
     autojump
     binutils
     cmake
     curl
     fd  # replaces 'find'
     file
	 fzf
     # lgogdownloader
     libtool
     lsof
     # libreoffice # too long to compile
	 gawk
     git
	 # git-extras # does not find it (yet)
     gnum4 # hum
     gnupg
     gnumake
     htop

     # ipsecTools # does it provide ipsec ?
     neovim # TODO remake a custom one
     pkgconfig
     pstree

     # for fuser, useful when can't umount a directory
     # https://unix.stackexchange.com/questions/107885/busy-device-on-umount
     psmisc
     pv # monitor copy progress
     ranger
     rsync
     ripgrep
     stow
     sudo
     tig
	 unzip
     vifm
     vim
     wget
     zsh
]
