# enable this module to work with a microsoft environment
#
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.microsoft;
in
{
  options = {
    microsoft = {
      enable = lib.mkEnableOption "microsoft";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {

    home.packages = [
      pkgs.teams-for-linux
      pkgs.remmina
    ];
  };
}
