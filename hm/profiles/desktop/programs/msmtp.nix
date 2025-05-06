{
  config,
  lib,
  pkgs,
  ...
}:
{
    enable = true;
    # TODO add default account ?
    extraConfig = ''
      # this will create a default account which will then break the
      # default added via primary
      syslog         on
    '';

}
