{
  config,
  lib,
  # pkgs,
  ...
}:
let
  # .local ?
  # suffix = config.networking.fqdnOrHostName;

  # I want to be able to access those services
  mkServerAliases = prefix: [
    "${prefix}.home"
    "${prefix}.local"
    "${prefix}.vpn"
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

  # using avahi hotname
  virtualHosts = {
    harmonia = {
      enableACME = false;
      forceSSL = false;

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

    # optionaal depending on user service
    llamacpp = lib.mkIf llama-cpp-service.enable {
      enableACME = false;
      forceSSL = false;

      # serverName =
      serverAliases = mkServerAliases "llamacpp";

      locations."/" = {
        proxyPass = "http://localhost:${toString llama-cpp-service.port}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 100M;
        '';

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

    faster-whisper = lib.mkIf (config.services.wyoming.faster-whisper.servers != [ ]) {
      serverAliases = mkServerAliases "whisper";

      enableACME = false;
      forceSSL = false;

      locations."/" = {
        proxyPass = "http://localhost:10301";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 100M;
        '';

      };
    };

    piper = lib.mkIf (config.services.wyoming.piper.servers != [ ]) {
      enableACME = false;
      forceSSL = false;
      serverAliases = mkServerAliases "piper";

      locations."/" = {
        proxyPass = "http://localhost:10200";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 100M;
        '';

      };
    };

  };
}
