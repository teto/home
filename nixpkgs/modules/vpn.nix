{ config, lib,  pkgs, ... }:
{
  # services.xl2tpd = {
  #   enable = true;
  #   # serverIP =
  # };

  services.strongswan = {
    enable = true;
      # "/etc/ipsec.d/*.secrets" "/etc/ipsec.d"
    secrets = ["/etc/ipsec.d"];
  };

}
