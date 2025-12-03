{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.wallust;
in
{
  options = {
    programs.wallust = {
      enable = lib.mkEnableOption "wallust";
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
