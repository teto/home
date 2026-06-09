{
  config,
  lib,
  secretsFolder,
  ...
}:
{
  networkmanager = {
    enable = true;
  };

  useNetworkd = true;

  hosts = {
    # a test, better would be to have nginx recognize another thing
    "10.100.0.1" = [ "neotokyo.local" ];
  };

  firewall.allowedTCPPorts = lib.optional config.services.rmfakecloud.enable config.services.rmfakecloud.port;

  firewall.allowedUDPPorts = [
    51820 # wireguard
  ];
}
