{ config, lib, pkgs, ... }:
{
  services.openntpd = {
    enable = true;
    # add iij ntp servers
    # servers = [ "" ];
    # extraConfig="";
    # extraOptions="";
    servers = [ "0.nixos.pool.ntp.org" "1.nixos.pool.ntp.org" "2.nixos.pool.ntp.org" "3.nixos.pool.ntp.org" ];
  };

  services.timesyncd = {
    enable = false;
  };

}
