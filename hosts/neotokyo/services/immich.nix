{ dotfilesPath
, secrets
, pkgs
, ... }:
{
  imports = [
    ../../../nixos/profiles/immich.nix
  ];
  services.immich = {
    enable = true;
    # host = ""; # all interfaces (example from module option) breaks with nginx

    machine-learning = {
      enable = true;
    };
    # secretsFile
    openFirewall = true;

    # https://immich.app/docs/install/environment-variables/
    environment = {
      IMMICH_LOG_LEVEL = "verbose";
    };

    # merged into environment
    # secretsFile = "/run/secrets/immich";
  };

  services.nginx.virtualHosts."immich.${secrets.jakku.hostname}" = {
        forceSSL = true;
        enableACME = true;
        # useACMEHost = "${secrets.jakku.hostname}";
        # listen on all interfaces
        # listen = [ { addr = "0.0.0.0"; port = 80; }];

        locations."/" = {
          #  echo $server_name;  # Will output the server name defined in the current server block
          proxyPass = "http://localhost:3001";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 100M;
          '';

        };

        root = pkgs.runCommand "testdir" { } ''
          mkdir "$out"
          echo this is immich > "$out/index.html"
        '';
      };

}
