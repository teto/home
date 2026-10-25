{
  # config,
  # lib,
  # pkgs,
  ...
}:
{
  enable = true;
  # announceInterval = 60;
  openFirewall = true;


  # there are udp errors when it binds to wireguard network ?

  settings = {
    # port=8200;
    # enable_subtitles
    friendly_name = "jedha";
    # inotify = "yes";
    log_level = "warn";
    media_dir = [ 
      # can be prefixed with V/A, to filter audio/video
      "/mnt/ext/music" 
    ];
    inotify = "yes";
    # db_dir =
  };
}
