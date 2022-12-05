{ config, lib, pkgs,  ... }:
{

  # environment.systemPackages = [
  #   pkgs.gnome.networkmanagerapplet
  # ];

  networking.networkmanager = {
    enable = true;
    # enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel = "TRACE";

    # may generate problems
    wifi.scanRandMacAddress = false;
    wifi.powersave = false;

    # for vpn dns
    # appendNameServers = [ ];

    # unmanaged = [
    #   "interface-name:r?-*"
    #   "interface-name:r?-*"
    #   "interface-name:client-*"
    #   "interface-name:server-*"
    #   ];


    # networking.resolvconfOptions
    # wifi.powersave=false;
    # TODO configure dispatcherScripts  for mptcp
  };

}

