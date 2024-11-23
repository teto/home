{
  config,
  secrets,
  lib,
  withSecrets,
  ...
}:
{

  programs.zsh = {

    enableTetoConfig = true;

    #  history = {
    #   path = "${config.xdg.cacheHome}/zsh_history";
    #  };

    # test for 
    # - https://www.reddit.com/r/neovim/comments/17dn1be/implementing_mru_sorting_with_minipick_and_fzflua/
    # - https://lib.rs/crates/fre
    initExtra = ''
      fre_chpwd() {
        fre --add "$(pwd)"
      }
      typeset -gaU chpwd_functions
      chpwd_functions+=fre_chpwd

       # if [ -f "$ZDOTDIR/zshrc" ]; then
       source $ZDOTDIR/zshrc
       # fi

    '';

    initExtraBeforeCompInit = # zsh
      ''
        # zsh searches $fpath for completion files
        fpath+=( $ZDOTDIR/completions )
      '';

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
