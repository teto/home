{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.librenms = {
    enable = true;
    database.createLocally = true;
    database.passwordFile = "/run/secrets/librenms";
  };

  sops.secrets."librenms" = {
    mode = "0440";
    # TODO only readable by gitlab
    owner = config.services.librenms.user;
    group = config.users.users.nobody.group;
  };

}
