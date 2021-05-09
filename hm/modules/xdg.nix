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
      CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config";
      CABAL_DIR="$XDG_CACHE_HOME/cabal";
      WEECHAT_HOME="$XDG_CONFIG_HOME/weechat";
    };
  };
}
