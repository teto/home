{ config, lib, pkgs, ... }:
{
  services.resolved= {
    enable = true;
    dnssec = "false"; # "allow-downgrade";
  };
  # allow-downgrade falls back when dnssec fails, "true" foces dnssec
  # services.resolved.dnssec = "allow-downgrade";


  networking.networkmanager = {
    enable = true;
    # enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel = "TRACE";

    # default is openresolv
    dns = "systemd-resolved";

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

