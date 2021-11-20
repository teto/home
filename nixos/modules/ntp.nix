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
    enable = false;
  };

  services.timesyncd = {
    enable = false;
  };

  services.chrony = {
    # if time is wrong:
    # 1/ systemctl stop chronyd.service
    # 2/ "chronyd -q 'pool pool.ntp.org iburst'"
    enable = true;
  };

}
