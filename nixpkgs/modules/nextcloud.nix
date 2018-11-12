{ config, lib, pkgs,  ... }:
let
  secrets = import ../secrets.nix;
in
{

  services.nextcloud = {
    enable = true;
    # machine specific
    # hostName = "toto.com";
    nginx.enable = true;
    config = {
      adminpass = secrets.nextcloud.password;
    };
    maxUploadSize = "512M";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
