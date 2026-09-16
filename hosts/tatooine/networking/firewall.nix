{ config, lib, ... }:
{
  allowedTCPPorts =
    lib.optional config.services.rmfakecloud.enable config.services.rmfakecloud.port
    ;

  allowedUDPPorts = [
    51820 # wireguard
  ];
}
