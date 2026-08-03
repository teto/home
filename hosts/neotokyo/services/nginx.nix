{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  # config.services.jellyfin.port doesn't exist
  # toString config.services.jellyfin.port
  defaultJellyfinPort = 8096;

  # get it from wireguard config:w
  wgEndpoint = "10.100.0.1";

  errorPageRoot = pkgs.writeTextDir "404.html" ''
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex">
        <title>404 — Page not found</title>
        <style>
          :root {
            color-scheme: dark;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
              "Liberation Mono", "Courier New", monospace;
            background: #080b12;
            color: #d8e2ff;
          }

          * { box-sizing: border-box; }

          body {
            min-height: 100vh;
            margin: 0;
            display: grid;
            place-items: center;
            overflow: hidden;
            background:
              radial-gradient(circle at 50% 30%, #172445 0, transparent 42%),
              repeating-linear-gradient(
                0deg,
                transparent 0,
                transparent 3px,
                rgb(255 255 255 / 0.025) 4px
              ),
              #080b12;
          }

          main {
            width: min(42rem, calc(100% - 2rem));
            padding: clamp(2rem, 7vw, 4.5rem);
            border: 1px solid #2c4070;
            background: rgb(8 11 18 / 0.82);
            box-shadow: 0 0 4rem rgb(45 106 255 / 0.15);
            text-align: center;
          }

          .code {
            margin: 0;
            color: #67e8f9;
            font-size: clamp(5rem, 22vw, 10rem);
            font-weight: 800;
            line-height: .8;
            letter-spacing: -.08em;
            text-shadow: .04em .04em 0 #be3cff;
          }

          h1 {
            margin: 2rem 0 .75rem;
            font-size: clamp(1.25rem, 4vw, 1.75rem);
            letter-spacing: .08em;
            text-transform: uppercase;
          }

          p {
            margin: 0 auto 2rem;
            max-width: 30rem;
            color: #94a3c7;
            line-height: 1.7;
          }

          a {
            display: inline-block;
            padding: .8rem 1.1rem;
            border: 1px solid #67e8f9;
            color: #67e8f9;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: .08em;
          }

          a:hover, a:focus-visible {
            background: #67e8f9;
            color: #080b12;
            outline: none;
          }
        </style>
      </head>
      <body>
        <main>
          <p class="code" aria-label="Error 404">404</p>
          <h1>Signal lost</h1>
          <p>The page you were looking for has moved, vanished, or never existed.</p>
          <a href="/">Return home</a>
        </main>
      </body>
    </html>
  '';
in
{

  #additionalModuleos defaultJellyfinPort

  # users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {

    # tailscaleAuth.enable
    # A list of nginx virtual hosts to put behind tailscale.nginx-auth

    # services.nginx.tailscaleAuth.virtualHosts = []

    recommendedGzipSettings = true;
    # recommendedOptimisation = true;
    # recommendedProxySettings = true;
    recommendedTlsSettings = true;

    additionalModules = [
      # pkgs.nginxModules
    ];
    # commonHttpConfig
    # appendConfig = ''
    #   '';

    # Reload nginx when configuration file changes (instead of restart).
    # The configuration file is exposed at /etc/nginx/nginx.conf
    enableReload = true;

    # Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
    statusPage = true;
    validateConfigFile = true;

    logError = "stderr";
    # logError = "syslog:debug";

    virtualHosts = {

      # to avoid https:// redirecting to the first random virtual host
      # we should even return a special type -> redirect to blog ?
      "_tls-catchall" = {
        # doesn't act as default because doesn't have force 
        default = true;
        addSSL = false;
        # use step-ca instead
        #               # proxyPass = "http://unix:${webUnixSocket}";
        # sslCertificate = "/path/to/internal-cert.pem";
        # sslCertificateKey = "/path/to/internal-key.pem";
        extraConfig = "return 444;";
      };

      "blog.${secrets.jakku.hostname}" = {

        # I had to manually "chmod a+x /var/lib/gitolite"
        root = "/var/www/blog-generated";
        extraConfig = ''
          error_page 404 /404.html;
        '';

        # Makes this vhost the default.
        # default = true;

        forceSSL = true;
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        # enableACME = true; # exclusive with useACMEHost
        useACMEHost = "blog.${secrets.jakku.hostname}";
        # All serverAliases will be added as extra domain names on the certificate.
        serverAliases = [
          # "blog.${secrets.jakku.hostname}"
          "${secrets.jakku.hostname}"
          "www.${secrets.jakku.hostname}"
        ];
        # Directory for the ACME challenge, which is public. Don’t put certs or keys in here. Set to null to inherit from config.security.acme.
        # acmeRoot = "/var/lib/acme/challenges-de";

        # root /home/username/mysite/public/; #Absolute path to where your hugo site is
        # index index.html; # Hugo generates HTML
        # looking at https://gideonwolfe.com/posts/sysadmin/hugonginx/
        locations."/" = {
          extraConfig = ''
            try_files $uri $uri/ =404;
          '';
        };

        locations."= /404.html" = {
          root = errorPageRoot;
          extraConfig = "internal;";
        };
      };

      "status.${secrets.jakku.hostname}" = {
        root = pkgs.runCommand "testdir" { } ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';

      };
    }
    // lib.optionalAttrs config.services.immich.enable {

      # "immich.${secrets.jakku.hostname}" = {
      "immich.vps" = {
        forceSSL = true;
        enableACME = true;
        # useACMEHost = "${secrets.jakku.hostname}";
        # listen on all interfaces
        # listen = [ { addr = "0.0.0.0"; port = 80; }];
        listenAddresses = [
          wgEndpoint
        ];

        locations."/" = {
          #  echo $server_name;  # Will output the server name defined in the current server block
          proxyPass = "http://localhost:${toString config.services.immich.port}";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 100M;
          '';

        };
      };

    }

    // lib.optionalAttrs config.services.jellyfin.enable {
      # inspired by nixaar project
      # "jellyfin.${secrets.jakku.hostname}" = {
      "jellyfin.vps" = {

        listenAddresses = [
          wgEndpoint
        ];

        enableACME = false;
        forceSSL = false;
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;

          proxyPass = "http://127.0.0.1:${toString defaultJellyfinPort}";
        };
      };
    }
    // lib.optionalAttrs config.services.buildbot-nix.master.enable {
      "${config.services.buildbot-nix.master.domain}" = {
        enableACME = true;
        forceSSL = true;

      };
    }
    // lib.optionalAttrs config.services.harmonia.cache.enable {
      # harmonia
      "cache.${secrets.jakku.hostname}" = {
        enableACME = true;
        forceSSL = true;

        # TODO replace with harmonia's port
        locations."/".extraConfig = ''
          proxy_pass http://127.0.0.1:5000;
          proxy_set_header Host $host;
          proxy_redirect http:// https://;
          proxy_http_version 1.1;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
      };
    }
    // lib.optionalAttrs config.services.n8n.enable {
      "n8n.${secrets.jakku.hostname}" = {
        locations."/" = {
          recommendedProxySettings = true;
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString config.services.n8n.environment.N8N_PORT}";
        };
      };
    }
    // lib.optionalAttrs config.services.nextcloud.enable {

  # create some errors on deploy
  # for now we generate one certificate per virtual host
  # https://discourse.nixos.org/t/nixos-nginx-acme-ssl-certificates-for-multiple-domains/19608/2

    # ceeformat is unknown ?

      # the n
      # extends the host already configured by the nixos module nginx
      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;

        # proxyWebsockets = true
        # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
        # enable step-ca generated
        enableACME = true;
        # enableReload = true; # reloads service when config changes !

        listenAddresses = [
          wgEndpoint
        ];

        # listen = [ 80 ];
        # listen = [ { addr = "127.0.0.1"; port = 80; }];
        # locations."/" = {
        #   proxyPass = "http://localhost:8080"; # Assuming service 1 runs on localhost:8080
        # };
        #
        # extraConfig = ''
        #   allow 193.168.0.1/24;
        #   deny all;
        # '';
      };

    };
  };

}
