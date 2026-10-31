# advertise for amp
{
  ...
}:
{
  enable = true;
  # announceInterval = 60;
  # to receive sssdp answers
  openFirewall = true;


  # there are udp errors when it binds to wireguard network ?

  settings = {
    # port=8200;
    # enable_subtitles
    friendly_name = "tatooine";
    # inotify = "yes";
    log_level = "warn";
    media_dir = [ 
      # can be prefixed with V/A, to filter audio/video
      "/home/teto/videos"
      "/home/teto/Music"
    ];
    inotify = "yes";
    # db_dir =
  };
}


