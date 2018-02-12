{ config, lib, pkgs,  ... }:
{
  networking.networkmanager = {
    enable=true;
    enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel="INFO";
    wifi.scanRandMacAddress = true;

    # networking.resolvconfOptions
    # wifi.powersave=false;
    # TODO configure dispatcherScripts  for mptcp
  };

}

