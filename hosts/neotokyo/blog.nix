{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  services.nginx = {
    enable = true;
    virtualHosts."www.neotokyo.com" = {
      # This makes things work nicely when we're not deployed to the 
      # real host, so hostnames don't match
      default = true;

      locations."/blog" = {
        alias = pkgs.callPackage ../blog/build/default.nix { };
      };
      locations."/.well-known" = {
        alias = ../well-known;
      };

      extraConfig = "rewrite ^/$ /blog redirect;";
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];
}
