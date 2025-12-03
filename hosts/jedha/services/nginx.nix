{
  config,
  lib,
  pkgs,
  ...
}:
{
  enable = true;
  recommendedTlsSettings = false;

  # using avahi hotname
  virtualHosts."${config.networking.hostName}" = {
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
