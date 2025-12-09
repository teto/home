{ config, lib, pkgs, ... }:
{
  
  enable = true;

  # credentialsFile = 
  # downloadDirPermissions = "750";
  # home = "/var/lib/transmission";
  # openPeerPorts
  # openRPCPort
  package = pkgs.transmission_4;

  settings = {

    watch-dir-enabled = true;
    incomplete-dir-enabled = true;

    # TODO add tmpfiles rules to create these folders
    watch-dir = "/home/teto/torrents";
    # add it to jellyfin library or 
    download-dir = "/home/teto/transmission-downloads";
    incomplete-dir = "/home/teto/transmission-downloads-in-progress";
  };
}
