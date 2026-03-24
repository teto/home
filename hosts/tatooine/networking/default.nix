{ config, lib, ... }:
{
  networkmanager = {
    enable = true;
  };

  firewall.allowedTCPPorts = lib.optional config.services.rmfakecloud.enable config.services.rmfakecloud.port;
}
