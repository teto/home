{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  services.rmfakecloud = {
    enable = true;

    # values at LOGLEVEL
    environmentFile = null; # "/etc/secrets/rmfakecloud.env";
    # storageUrl = "remarkable.${secrets.jakku.hostname}";
    storageUrl = "http://localhost";
    # extraSettings = {
    #
    # };

  };

}
