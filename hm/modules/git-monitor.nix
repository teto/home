{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.git-monitor;
in
{
  options = {
    services.git-monitor = {
      enable = lib.mkEnableOption "git-monitor";
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

  };
}
