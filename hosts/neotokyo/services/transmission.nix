{ config, lib, pkgs, ... }:
{
  
  enable = true;

  user = "transmission";
  group = "media"; # not secure enough but let's try ?

  # services.transmission.home
  #     The directory where Transmission will create ‘.config/transmission-daemon’. as well as ‘Downloads/’ unless services.transmission.settings.download-dir[1] is changed, and
  #     ‘.incomplete/’ unless services.transmission.settings.incomplete-dir[2] is changed.


  # credentialsFile = 
  # downloadDirPermissions = "750";
  # home = "/var/lib/transmission";
  # openPeerPorts
  # openRPCPort
  package = pkgs.transmission_4;

  extraFlags = [
    "--log-debug"
  ];

  settings = {
    # TODO once download finished, file should be moved to a folder
    # in read-only mode
    # script-torrent-done-enabled

    watch-dir-enabled = true;
    incomplete-dir-enabled = true;

    # TODO add tmpfiles rules to create these folders
    # allow everyone to reach this folder ?
    watch-dir = "/home/teto/torrents";
    # add it to jellyfin library or 
    download-dir = "/home/jellyfin/movies";
    incomplete-dir = "/home/jellyfin/transmission-downloads-in-progress";
  };
}
