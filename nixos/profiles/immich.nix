{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{

  services.immich = {
    package = pkgs.immich-no-ad;
    machine-learning = {
      enable = false;
    };
    # python3.11-insightface-0.7.3
    # server.typesense.apiKeyFile = typesenseApiKeyFile;
  };

  # services.typesense = {
  #   enable = true;
  #   # In a real setup you should generate an api key for immich
  #   # and not use the admin key!
  #   apiKeyFile = typesenseApiKeyFile;
  #   settings.server.api-address = "127.0.0.1";
  # };

}
