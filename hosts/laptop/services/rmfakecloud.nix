{ secrets, ... }:
{

  enable = false;
  # values at LOGLEVEL
  environmentFile = null; # "/etc/secrets/rmfakecloud.env";
  storageUrl = "remarkable.${secrets.jakku.hostname}";
  # extraSettings = {
  #
  # };
}
