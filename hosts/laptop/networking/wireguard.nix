{ config, lib, pkgs, ... }:
{
    
  networking.wireguard.interfaces = {
   wg = {

      ips = [ "10.100.0.3/24" ];

   };
  };
}
