{ secrets, ... }:
{
  # we are using wireguard so far
  enable = false;

  # listening on
  address = "0.0.0.0";

  # needs a postgres DB
  settings.dns = {
    # not registered yet
    base_domain = "headscale.${secrets.jakku.hostname}";
    override_local_dns = false;
  };
}
