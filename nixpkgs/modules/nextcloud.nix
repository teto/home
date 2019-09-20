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

  # ${secrets.gitolite_server.hostname}
  security.acme.certs."${secrets.gitolite_server.hostname}" = {
    webroot = "/var/www/challenges";
    email = "foo@example.com";
  };

  # create some errors on deploy
  # services.nginx.virtualHosts = { 
  #   # "cloud.acelpb.com" = {... }
  #   "${secrets.gitolite_server.hostname}" = {
  #     forceSSL = false;
  #   };
  # };
}
