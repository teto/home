# doc at 
# - https://wiki.nixos.org/wiki/Hedgedoc
# - https://discourse.nixos.org/t/does-anyone-know-how-to-configure-hedgedoc/33513/4
{ config
, lib
, pkgs
, secrets
, ...
}:
let 
  hedgedocDomain =  "hedgedoc.${secrets.jakku.hostname}";
in
{
  
  services.hedgedoc = {
    enable = true;
    configureNginx = true;

    settings = {
      domain = hedgedocDomain;

      # protocolUseSSL = true;
      # uploadsPath =
      allowOrigin = [
          "localhost"
          hedgedocDomain
          # "hedgedoc.${secrets.jakku.hostname}"
      ];
    };
  };

  services.nginx.virtualHosts."${hedgedocDomain}" = {
    forceSSL = true;
    enableACME = true;
    # useACMEHost = "${secrets.jakku.hostname}";
    # listen on all interfaces
    # listen = [ { addr = "0.0.0.0"; port = 80; }];

    locations."/" = {
      #  echo $server_name;  # Will output the server name defined in the current server block
      # TODO refer to the port
      # proxyPass = "http://localhost:3000";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 100M;
      '';

    };

  };

  # services.nginx.virtualHosts."immich.${secrets.jakku.hostname}" = {


}
