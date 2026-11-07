# advertise for amp
# sudo chmod -R o+rX /srv/media
# sudo chmod -R o+rX /srv/media
# sudo setfacl -m u:minidlna:--x /home/teto
# sudo setfacl -R -m u:minidlna:r-X /home/teto/Music
# sudo setfacl -m d:u:minidlna:r-X /home/teto/Music
{
  ...
}:
{
  enable = false;
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

    # Network interface to bind (optional; self-discovers if commented out)
    # to avoid erros on wireguard if
    network_interface="wlp2s0"; 
    # to remove warnings
    inotify = "no";
    # db_dir =
  };
}


