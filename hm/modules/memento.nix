{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.memento;
in
{
  options = {
    programs.memento = {
      enable = lib.mkEnableOption "memento";
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

    xdg.configFile."memento/mpv.conf".text = config.xdg.configFile."mpv/mpv.conf".text;

  };
}
