{ config, lib, pkgs, ... }:
let
   cfg = config.programs.fre;
in {
  options = {
    programs.pimsync = {
      enable = lib.mkEnableOption "fre";
    };
  };

  config =  lib.mkMerge [

    (lib.mkIf cfg.enable {
      xdg.configFile = {
        "pimsync/pimsyncrc" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
          recursive = true;
        };
        # ...
      };

      # programs.pimsync.initExtra = ''
      #   fre_chpwd() {
      #     fre --add "$(pwd)"
      #   }
      #   typeset -gaU chpwd_functions
      #   chpwd_functions+=fre_chpwd
      #   '';

      })


  ];

}

