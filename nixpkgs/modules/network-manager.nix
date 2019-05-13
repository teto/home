{ config, lib, pkgs,  ... }:
{

  # environment.systemPackages = [
  #   pkgs.gnome3.networkmanagerapplet
  # ];

  networking.networkmanager = {
    enable=true;
    # enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    logLevel="TRACE";

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

    # TODO reestablish with the correct nixpkgs !
    # dispatcherScripts = [
    #   {
    #     source = ./mptcp_up ;
    #     type = "up";
    #   }
    #   {
    #     source = ./mptcp_down ;
    #     type = "down";
    #   }
    #   ];

    # networking.resolvconfOptions
    # wifi.powersave=false;
    # TODO configure dispatcherScripts  for mptcp
  };

}

