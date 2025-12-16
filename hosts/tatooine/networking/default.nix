{ config, lib, ... }:
{
  

  firewall.allowedTCPPorts =
    lib.optional config.services.rmfakecloud.enable
    config.services.rmfakecloud.port
    ;
}
