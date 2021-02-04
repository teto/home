{ config, lib, pkgs, ... }:
{
  services.openntpd = {
    enable = false;
    # add iij ntp servers
    # servers = [ "" ];
    # extraOptions="";
    servers = [
      # "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      # "3.nixos.pool.ntp.org"
    ];
    extraConfig = ''
      server 0.nixos.pool.ntp.org trusted
      constraints from "https://www.google.com/"
      constraints from "https://www.nixos.org/"
    '';
  };


  services.ntp = {
    enable = true;
  };

  services.timesyncd = {
    enable = false;
  };

}
