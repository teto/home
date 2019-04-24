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
    logLevel = 0;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.virtualHosts = { 
    # "cloud.acelpb.com" = {... }
    "${secrets.gitolite_server.hostname}" = {
      forceSSL = true;
    };
  };
}
