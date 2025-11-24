{
  config,
  lib,
  pkgs,
  ...
}:
{

  # TODO leverage nixos module to generate notifs
  extraConfig = ''
    Defaults        timestamp_timeout=60
  '';

}
