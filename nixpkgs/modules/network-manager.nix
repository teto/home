{ config, lib, pkgs,  ... }:
{

  # environment.systemPackages = [
  #   pkgs.gnome3.networkmanagerapplet
  # ];

  networking.networkmanager = {
    enable=true;
    # enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    logLevel="DEBUG";
    wifi.scanRandMacAddress = true;

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
