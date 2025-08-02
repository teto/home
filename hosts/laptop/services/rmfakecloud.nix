{ secrets, ... }:
{

  enable = false;
  environmentFile = "/etc/secrets/rmfakecloud.env";
  storageUrl = "remarkable.${secrets.jakku.hostname}";
  # extraSettings = {
  #
  # };
}
