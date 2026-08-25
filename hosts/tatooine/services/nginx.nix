{
  config,
  lib,
  ...
}:
let 
  server = config.networking.hostName;
in
{
  enable = false;
  recommendedTlsSettings = false;

  # using avahi hotname
  virtualHosts = {
    "${server}" = {
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
    }
    # check llama-cpp
    // lib.optionalAttrs config.home-manager.users.teto.services.llama-cpp.enable {
      "llamacpp.${server}" = {
        enableACME = false;
        forceSSL = false;

      };
    }
    // lib.optionalAttrs config.services.wyoming.openwakeword.enable {
      "wyoming.${server}" = {
        enableACME = false;
        forceSSL = false;

      };

    };
}

