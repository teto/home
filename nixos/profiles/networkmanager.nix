{
  config,
  lib,
  pkgs,
  ...
}:
{
  # allow-downgrade falls back when dnssec fails, "true" foces dnssec

  # quad9
  # networking.nameservers = [ "9.9.9.9" ];

  networking.networkmanager = {
    # enableStrongSwan = true;
    # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
    # logLevel = "TRACE";

    # default is openresolv
    # dns = if config.services.adguardhome.enable then "none" else "systemd-resolved";
    dns = "systemd-resolved";

    appendNameservers = [
      # refers to adguard home
      "127.0.0.1"
    ];

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

    # ensureProfiles = {
    #   environmentFiles = "/home/joe/.wifi";
    #
    #   # Note the network will be called `REDACTED` in your UIs, but that
    #   # does not have to be the same as the SSID
    #   profiles."REDACTED" = {
    #     connection = {
    #       id = "REDACTED";
    #       type = "wifi";
    #       autoconnect = true;
    #     };
    #   };
    # };

  };

}
