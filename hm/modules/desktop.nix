{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ddcui;
in
{
  options = {
    programs.ddcui = {
      enable = lib.mkEnableOption "ddcui" // {
        description = "For screen ";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.ddcui
    ];
  };
}
