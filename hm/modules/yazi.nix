{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.yazi;
in
{
  options = {
    programs.yazi = {
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
