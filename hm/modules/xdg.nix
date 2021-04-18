{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.xdg;

in {

  options = {
    programs.xdg = {
      enable = mkEnableOption "XDG-like support";
    };
  };

  config = mkIf cfg.enable {

    # home.packages = [ pkgs.pywal ];
    home.sessionVariables = {

    };

  }
}
