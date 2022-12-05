{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.neovim;



in
{
  options = {
    enableNeorg = mkEnableOption "Neorg" // {
      description = "Don't load by default (load with :packadd)";
    };
    enableAutocompletion = mkEnableOption "nvim-cmp" // {
      description = "Don't load by default (load with :packadd)";
    };
  };


  config = lib.mkMerge [

    (mkIf cfg.enableNeorg {
      cfg.plugins = [ ];
    })

    (mkIf cfg.enableAutocompletion {
      cfg.plugins = [ ];
    })

  ];

}
