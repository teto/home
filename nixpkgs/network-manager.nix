{ config, lib, pkgs,  ... }:
{

  # environment.systemPackages = [
  #   pkgs.gnome3.networkmanagerapplet
  # ];

  networking.networkmanager = {
    enable=true;
    enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    logLevel="DEBUG";
    wifi.scanRandMacAddress = true;

    dispatcherScripts = [
      {
        source = /home/teto/testbed/mptcp_up ;
        type = "up";
      }
      {
        source = /home/teto/testbed/mptcp_down ;
        type = "post-down";
      }

      ];
    # networking.resolvconfOptions
    # wifi.powersave=false;
    # TODO configure dispatcherScripts  for mptcp
  };

}

