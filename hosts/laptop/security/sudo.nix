{
  config,
  lib,
  pkgs,
  ...
}:
{

  security.sudo.extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

}
