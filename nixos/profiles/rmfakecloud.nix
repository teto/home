{
  config,
  lib,
  pkgs,
  secrets
, ...
}:
{
  services.rmfakecloud = {
      enable = true;

  environmentFile = "/etc/secrets/rmfakecloud.env";
  storageUrl = "remarkable.${secrets.jakku.hostname}";
  # extraSettings = {
  #
  # };

  };

}
