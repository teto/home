{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = true;
  # announceInterval = 60;
  openFirewall = true;
  settings = {
    # enable_subtitles
    friendly_name = "MattTestServer";
    # inotify = "yes";
    log_level = "warn";
    media_dir = [ "/mnt/ext/Music" ];
  };
}
