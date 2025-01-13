{
  pkgs,
  lib,
  ...
}:
{

  programs.zsh = {

    enableTetoConfig = true;
    plugins = [
      # {
      #   name = "vi-mode";
      #   src = pkgs.zsh-vi-mode;
      #   file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      # }
    ];

    #  history = {
    #   path = "${config.xdg.cacheHome}/zsh_history";
    #  };

    # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

    # to disable loading of /etc/z* files
    # envExtra = ''
    # setopt no_global_rcs
    # '';
    # kernel aliases {{{
    # nix messes up the escaping I think
    # kernel_makeconfig=''
    #   nix-shell -E 'with import <nixpkgs> {}; mptcp-manual.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig ncurses ];})' --command "make menuconfig KCONFIG_CONFIG=$PWD/build/.config"
    #   '';
    # kernel_xconfig=''
    # nix-shell -E 'with import <nixpkgs> {}; linux.overrideAttrs (o: {nativeBuildInputs=o.nativeBuildInputs ++ [ pkgconfig qt5.qtbase ];})' --command 'make menuconfig KCONFIG_CONFIG=$PWD/build/.config'
    # '';
    # kernel_xconfig="make xconfig KCONFIG_CONFIG=build/.config"
    # }}}

    # custom module
    # autosuggestion.enable = true;
    autosuggestion.enable = lib.mkForce false;
    autosuggestion.highlight = "fg=#d787ff,bold";

  };
}
