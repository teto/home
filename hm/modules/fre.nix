# https://github.com/camdencheek/fre
{ config, lib, pkgs, ... }:
let
   cfg = config.programs.fre;
in {
  options = {
    programs.fre = {
      enable = lib.mkEnableOption "fre";
      enableAsFzfFile = lib.mkEnableOption "fre";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };

  config =  lib.mkMerge [

    (lib.mkIf cfg.enable {

    programs.zsh.initExtra = ''
      fre_chpwd() {
        fre --add "$(pwd)"
      }
      typeset -gaU chpwd_functions
      chpwd_functions+=fre_chpwd
      '';

    })

    (lib.mkIf cfg.enableAsFzfFile {
        programs.fzf.fileWidgetCommand = "command fre --sorted"; 
    })

  ];

}
