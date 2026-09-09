/*
Some of the domains are self-certified via step-ca
make sure domains are a match else you get errors like:
  `security.acme.certs.blog.neotokyo.fr.dnsProvider`,
  `security.acme.certs.blog.neotokyo.fr.webroot`,
  `security.acme.certs.blog.neotokyo.fr.listenHTTP` and
  `security.acme.certs.blog.neotokyo.fr.s3Bucket`
  is required.
https://nixos.org/manual/nixos/stable/index.html#module-security-acme


enableACME => asks lets encrypt : it is misnamed

parts of the ACME configuration happens in security.nix, to ask step-ca for VPN certs
*/
{
  config,
  lib,
  pkgs,
  secrets,
  withSecrets,
  ...
}:
let
  # config.services.jellyfin.port doesn't exist
  # toString config.services.jellyfin.port
  defaultJellyfinPort = 8096;


  # https://blog.stephane-robert.info/docs/services/web/nginx/#s%C3%A9curisation
  # rate-limiting
  nginxDoc = ''
  server {
      # Empêche le clickjacking
      add_header X-Frame-Options "SAMEORIGIN" always;

      # Empêche le sniffing MIME
      add_header X-Content-Type-Options "nosniff" always;

      # Politique de référent
      add_header Referrer-Policy "strict-origin-when-cross-origin" always;

      # HSTS (après avoir vérifié que HTTPS fonctionne)
      add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

      # CSP basique (à adapter selon votre app)
      add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline';" always;
  }'';

  # todo share it in contrib or something
  errorPageRoot = pkgs.writeTextDir "404.html" ./404.html;
in
{
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
      # "_tls-catchall" = {
      #   # doesn't act as default because doesn't have force
      #   default = true;
      #   addSSL = true;
      #   # use step-ca instead
      #   # # proxyPass = "http://unix:${webUnixSocket}";
      #
      #   # TODO this is mandatory
      #   # sslCertificate = "/path/to/internal-cert.pem";
      #   # sslCertificateKey = "/path/to/internal-key.pem";
      #   extraConfig = "return 444;";
      # };

    }
    // lib.optionalAttrs withSecrets (
      let 
        fqdn = config.networking.fqdn;
        # get it from wireguard config
        # TODO reference tetos.wireguard
        # "10.100.0.1";
        wgEndpoint = lib.wireguard.mkPeerIp 1;

      in
      {

        "blog.${fqdn}" = {

          # I had to manually "chmod a+x /var/lib/gitolite"
          root = "/var/www/blog-generated";
          extraConfig = ''
            error_page 404 /404.html;
          '';

          # Makes this vhost the default.
          default = true;

          forceSSL = true;
          # https://nixos.org/manual/nixos/stable/index.html#module-security-acme
          # enableACME = true; # exclusive with useACMEHost
          useACMEHost = "blog.${fqdn}";
          # All serverAliases will be added as extra domain names on the certificate.
          serverAliases = [
            "${fqdn}"
            "www.${fqdn}"
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

        "status.${fqdn}" = {
          root = pkgs.runCommand "testdir" { } ''
            mkdir "$out"
            echo hello world > "$out/index.html"
          '';

        };
      }
      // lib.optionalAttrs config.services.immich.enable {

        "immich.vps" = {
          forceSSL = true;
          enableACME = true;
          # useACMEHost = "immich.vps";
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
      // lib.optionalAttrs config.services.hedgedoc.enable (
        let
  hedgedocDomain = "hedgedoc.${secrets.jakku.hostname}";
in

        {
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

      })

      // lib.optionalAttrs config.services.harmonia.cache.enable {
        # harmonia
        "cache.${fqdn}" = {
          enableACME = true;
          forceSSL = true;

          serverAliases = [
            # TODO
            # "${fqdn}.vps"
          ];

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
        "n8n.${fqdn}" = {
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

      # extends the host already configured by the nixos module nginx
      # nextcloud.vps

      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;

        # enable letsencrypt
        enableACME = true;
        # enable step-ca generated
        # useACMEHost = "nextcloud.vps";


        # proxyWebsockets = true
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

    }
    // lib.optionalAttrs config.services.jellyfin.enable {
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
    // lib.optionalAttrs config.services.nixbot.enable {
      "${config.services.nixbot.domain}" = {
        enableACME = true;
        forceSSL = true;

      };
    });
  };

}
