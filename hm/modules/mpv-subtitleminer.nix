{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.mpv-subtitleminer;
in
{
  options = {
    programs.mpv-subtitleminer = {
      enable = lib.mkEnableOption "mpv-subtitleminer";
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
