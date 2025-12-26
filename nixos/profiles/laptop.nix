{
  config,
  lib,
  pkgs,
  ...
}:
{

  # bluetuith # Bluetooth TUI

  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test
}
