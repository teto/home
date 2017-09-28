{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
     automake
     autoconf
     autojump
     cmake
     curl
     fd # replaces 'find'
	 fzf
     # lgogdownloader
     libtool
     # libreoffice # too long to compile
	 gawk
     git
	 # git-extras # does not find it (yet)
     gnum4 # hum
     gnupg
     ipsecTools # does it provide ipsec ?
     neovim
     pkgconfig
     ranger
     ripgrep
     stow
     sudo
	 unzip
     vim
     wget
     zsh
];
}
