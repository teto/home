{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  services.rmfakecloud = {

    # port = 3000;
    # values at LOGLEVEL
    environmentFile = null; # "/etc/secrets/rmfakecloud.env";
    # storageUrl = "remarkable.${secrets.jakku.hostname}";
    storageUrl = "http://tatooine.local";
       # services.rmfakecloud.storageUrl
       #     URL used by the tablet to access the rmfakecloud service.

    # extraSettings = {
    #
    # };
  };

  # networking.firewall.allowedTCPPorts = [ config.services.rmfakecloud.port ];

}
