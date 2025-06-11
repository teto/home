{ config, lib, pkgs, ... }:
let
   cfg = config.hibernation;
in {
  options = {
    programs.hibernation = {
      enable = lib.mkEnableOption "hibernation";
      delay = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Delay before autohibernating
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
  };
}
