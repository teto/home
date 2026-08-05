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

      package = lib.mkPackageOption pkgs "memento" {
        # default = null;
        nullable = true;
        example = "pkgs.thunderbird-91";
      };

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

    # copy mpv generated config ? could be a symlink ?
    xdg.configFile."memento/mpv.conf".text = config.xdg.configFile."mpv/mpv.conf".text;

    home.packages = [
      cfg.package
    ];
  };
}
