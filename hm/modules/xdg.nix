{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xdg;

in
{

  options = {
    programs.xdg = {
      enable = mkEnableOption "XDG-like support";
    };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = {
      # INPUTRC = "$XDG_CONFIG_HOME/inputrc";
      # CABAL_CONFIG = "${config.home.sessionVariables.XDG_CONFIG_HOME}/cabal/config";
      # TODO move to data instead ?
      # CABAL_DIR = "${config.home.sessionVariables.XDG_CACHE_HOME}/cabal";
    };
  };
}
