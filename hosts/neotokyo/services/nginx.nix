{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{

  services.nginx = {
    # Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
    statusPage = true;
    validateConfigFile = true;

    virtualHosts = {
      "blog.${secrets.jakku.hostname}" = {
        forceSSL = false;
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        enableACME = false;
        listen = [
          {
            addr = "127.0.0.1";
            port = 4001;
          }
        ];

        root = pkgs.runCommand "testdir" { } ''
          mkdir "$out"
          echo "WIP" > "$out/index.html"
        '';

        # extraConfig = ''
        #   access_log syslog:server=unix:/dev/log,facility=user,tag=mytag,severity=info ceeformat;
        #   location /favicon.ico { allow all; access_log off; log_not_found off; }
        # '';

      };

      "status.${secrets.jakku.hostname}" = {
        root = pkgs.runCommand "testdir" { } ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';

      };
    };
  };
}
