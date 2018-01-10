{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; 
  let neovim-custom = neovim.override {
       configure = {
         customRC = ''
          # here your custom configuration goes!
         '';
         # packages.myVimPackage = with pkgs.vimPlugins; {
         #   # see examples below how to use custom packages
         #   # loaded on launch
         #   start = [ fugitive ];
         #   # manually loadable by calling `:packadd $plugin-name`
         #   opt = [ ];
         # };
       };
     }; in [
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
     ipsecTools # does it provide ipsec ?
     neovim-custom
     pkgconfig
     pstree
     ranger
     ripgrep
     stow
     sudo
     tig
	 unzip
     vim
     wget
     zsh
];
}
