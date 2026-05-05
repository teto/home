{ secrets, ... }:
{
  enable = true;

  # listening on
  address = "0.0.0.0";

  # needs a postgres DB
  settings.dns = {
    base_domain = "tailnet.${secrets.jakku.hostname}";
    override_local_dns = false;
  };
}
