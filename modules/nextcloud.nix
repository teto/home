{ config, lib, pkgs, ... }:
let
  secrets = import ../nixpkgs/secrets.nix;
in
{

  services.nextcloud = {
    enable = true;
    # machine specific
    # hostName = "toto.com";
    config = {
      # loaded via sops 
      adminpassFile = "/run/secrets/nextcloud/adminPassword";
    };
    maxUploadSize = "512M";
    logLevel = 0;
    enableBrokenCiphersForSSE = false;
    package = pkgs.nextcloud25;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # ${secrets.gitolite_server.hostname}
  security.acme.certs."${secrets.jakku.hostname}" = {
    webroot = "/var/www/challenges";
    email = "foo@example.com";
  };

  sops.secrets."nextcloud" = {
    mode = "0440";
    owner = config.users.users.nobody.name;
    group = config.users.users.nobody.group;
  };

  # create some errors on deploy
  # services.nginx.virtualHosts = { 
  #   # "cloud.acelpb.com" = {... }
  #   "${secrets.gitolite_server.hostname}" = {
  #     forceSSL = false;
  #   };
  # };
}
