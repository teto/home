{ config, lib, pkgs, ... }:
let
   cfg = config.programs.neomutt;
in {
  options = {
    programs.neomutt = {
      enableVimKeys = lib.mkEnableOption "neomutt";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  config = lib.mkIf cfg.enableVimKeys {
  };
}
