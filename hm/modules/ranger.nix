{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ranger;

in
{

  options = {
    programs.ranger = {
      enable = mkEnableOption "Ranger";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      ffmpegthumbnailer # to preview videos in ranger
    ];

    home.sessionVariables = { };
  };
}
