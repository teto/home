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

    home.sessionVariables = {
      CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config";
      # TODO move to data instead ?
      CABAL_DIR="$XDG_CACHE_HOME/cabal";
    };
  };
}
