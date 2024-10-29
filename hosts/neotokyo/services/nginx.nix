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
        forceSSL = true;
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        enableACME = true;
        # listen = [
        #   {
        #     addr = "127.0.0.1";
        #     port = 4001;
        #   }
        # ];

        # try_files $uri $uri/ =404;
        # absolute path to where the site is
        # root = pkgs.runCommand "testdir" { } ''
        #   mkdir "$out"
        #   echo "WIP" > "$out/index.html"
        # '';

        # root /home/username/mysite/public/; #Absolute path to where your hugo site is
        # index index.html; # Hugo generates HTML
        # looking at https://gideonwolfe.com/posts/sysadmin/hugonginx/
        locations."/" = {
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };
        root = "/home/teto/blog";

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
