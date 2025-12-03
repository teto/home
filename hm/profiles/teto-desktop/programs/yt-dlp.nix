{
  config,
  lib,
  pkgs,
  ...
}:
let

in
{

  enable = true;
  # can symlinkJoin plugins under "yt-dlp-plugins"
  # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#installing-plugins
  package = pkgs.yt-dlp;
  settings = {
    embed-thumbnail = true;
    embed-subs = true;
    sub-langs = "all";
    # downloader = "aria2c";
    # downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
  };

  # plugins = {
  #
  # };
}
