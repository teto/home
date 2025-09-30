{
  dotfilesPath,
  secrets,
  pkgs,
  lib,
  ...
}:
{
  services.immich = {
    enable = true;
    # host = ""; # all interfaces (example from module option) breaks with nginx

    # The group immich should run as.
    group = "immich";

    machine-learning = {
      # enable = lib.mkForce true;
      enable = false;
    };
    # secretsFile
    openFirewall = true;

    # "IMMICH_MEDIA_LOCATION=/var/lib/immich"
    # https://immich.app/docs/install/environment-variables/
    environment = {
      IMMICH_LOG_LEVEL = "verbose";
    };

    # merged into environment
    # secretsFile = "/run/secrets/immich";
  };

  systemd.services.immich-server.serviceConfig = {
    # we override the default 0077 such that the backup job can read the files
    UMask = "0027";
  };

  services.nginx.virtualHosts."immich.${secrets.jakku.hostname}" = {
    forceSSL = true;
    enableACME = true;
    # useACMEHost = "${secrets.jakku.hostname}";
    # listen on all interfaces
    # listen = [ { addr = "0.0.0.0"; port = 80; }];

    locations."/" = {
      #  echo $server_name;  # Will output the server name defined in the current server block
      proxyPass = "http://localhost:2283";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 100M;
      '';

    };

  };

}
