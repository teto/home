{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nvimpager;
in
{
  options = {
    programs.nvimpager = {
      enable = lib.mkEnableOption "nvimpager";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nvimpager
    ];

    home.sessionVariables = {
      PAGER = "nvimpager";
    };
  };
}
