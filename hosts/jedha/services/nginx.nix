{
  config,
  lib,
  # pkgs,
  ...
}:
let
  # .local ?
  fqdn = config.networking.fqdnOrHostName;

  # I want to be able to access those services
  mkServerAliases = prefix: [
    "${prefix}.home"
    "${prefix}.local"
    "${prefix}.vpn"
    "${prefix}.${fqdn}"
  ];

  llama-cpp-service =
    config.home-manager.users.teto.services.llama-cpp.instances.default or {
      enable = false;
    };
in
{
  enable = true;
  recommendedTlsSettings = false;

  # Reload nginx when configuration file changes (instead of restart).
  # The configuration file is exposed at /etc/nginx/nginx.conf
  enableReload = true;

  # Enable status page reachable from localhost on http://127.0.0.1/nginx_status.
  statusPage = true;
  validateConfigFile = true;

  logError = "stderr";

  # Wyoming uses raw TCP; each service needs its own public port.
  # doc for stream https://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#server
  # I can set the resolver here resolver 127.0.0.1 [::1]:5353;
  # I could use socket paths as well
  # service=name
  #    enables resolving of DNS SRV records and sets the service name 
  streamConfig = let
    piperSrv = config.services.wyoming.piper.servers.fr;
    whisperSrv = config.services.wyoming.faster-whisper.servers.medium-fr;
  in
    # piper on 10200 a priori
    lib.optionalString piperSrv.enable ''
      server {
        listen 10222;
        proxy_pass 127.0.0.1:10200;
        fail_timeout 10s;
      }
    ''
    # 10301
    # invalid host in upstream "tcp://0.0.0.0:10200
    + lib.optionalString whisperSrv.enable ''
      server {
        listen 10333;
        proxy_pass 127.0.0.1:10301;
      }
    '';

  # using avahi hotname
  virtualHosts = {
    harmonia = lib.mkIf config.services.harmonia.cache.enable {
      enableACME = false;
      forceSSL = false;
      serverAliases = mkServerAliases "cache";

      locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:5000;
      #   proxy_set_header Host $host;
      #   proxy_redirect http:// https://;
      #   proxy_http_version 1.1;
      #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #   proxy_set_header Upgrade $http_upgrade;
      #   proxy_set_header Connection $connection_upgrade;
      '';
    };

    # optionaal depending on user service
    llamacpp = lib.mkIf llama-cpp-service.enable {
      enableACME = false;
      forceSSL = false;

      # serverName =
      serverAliases = mkServerAliases "llamacpp";

      locations."/" = {
        proxyPass = "http://localhost:${toString llama-cpp-service.port}";
        proxyWebsockets = false;
        # extraConfig = ''
        #   client_max_body_size 100M;
        # '';

      };
    };

    llama-rag = lib.mkIf llama-cpp-service.enable {
      enableACME = false;
      forceSSL = false;

      # serverName =
      serverAliases = mkServerAliases "llama-rag";

      locations."/" = {
        proxyPass = "http://localhost:9932";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 100M;
        '';
      };
    };

    music-assistant = lib.mkIf config.services.music-assistant.enable {
      enableACME = false;
      forceSSL = false;
      serverAliases = mkServerAliases "music-assistant";

      locations."/" = {
        proxyPass = "http://localhost:8097";
        proxyWebsockets = true;
      };
    };

  };
}
