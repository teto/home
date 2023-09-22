
{ config, lib, pkgs, secrets, ... }:
let
  # secrets = import ../nixpkgs/secrets.nix;

  # used to setup sops at the bottom of the file
  nextcloudAdminPasswordSopsPath = "nextcloud/adminPassword";

  typesenseApiKeyFile = pkgs.writeText "typesense-api-key" "12318551487654187654";

in
{
 # services.immich = {
 #  enable = false;
 #  # python3.11-insightface-0.7.3
 #      server.typesense.apiKeyFile = typesenseApiKeyFile;

 # };

    services.typesense = {
      enable = true;
      # In a real setup you should generate an api key for immich
      # and not use the admin key!
      apiKeyFile = typesenseApiKeyFile;
      settings.server.api-address = "127.0.0.1";
    };



 }
