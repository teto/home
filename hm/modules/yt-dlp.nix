{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.yt-dlp;
in
{
  # options = {
  #   programs.yt-dlp = {
  #     # enable = lib.mkEnableOption "yt-dlp";
  #     plugins = lib.mkOption {
  #       default = false;
  #       type = lib.types.listOf lib.types.package;
  #       description = ''
  #         A list of packages
  #       '';
  #     };
  #   };
  # };
  # config = lib.mkIf cfg.enable {
  # };
}
