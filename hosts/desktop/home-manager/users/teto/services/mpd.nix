{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/ext/music";

  };
}
