{
  config,
  lib,
  ...
}:
{
  networkmanager = {
    enable = true;
  };

  useNetworkd = true;

  hosts = {
    # a test, better would be to have nginx recognize another thing
    # todo use from lib
    "10.100.0.1" = [ "neotokyo.local" ];
  };

  firewall.allowedTCPPorts =
    lib.optional config.services.rmfakecloud.enable config.services.rmfakecloud.port
    ++ lib.optional config.services.wyoming.satellite.enable 10700
    ++ lib.optional config.services.wyoming.openwakeword.enable 10400
    ++ [
      10301 # whisper service
      # 10400 # openwakeword
    ];

  firewall.allowedUDPPorts = [
    51820 # wireguard
  ];
}
