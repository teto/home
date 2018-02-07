{ pkgs, ... }:
with pkgs; [
     automake
     autoconf
     autojump
     binutils
     cmake
     curl
     fd # replaces 'find'
     file
	 fzf
     # lgogdownloader
     libtool
     # libreoffice # too long to compile
	 gawk
     git
	 # git-extras # does not find it (yet)
     gnum4 # hum
     gnupg
     gnumake
     # ipsecTools # does it provide ipsec ?
     # neovim-custom # TODO remake a custom one
     pkgconfig
     pstree
     # ranger
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
