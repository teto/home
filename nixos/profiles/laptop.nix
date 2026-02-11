{
  config,
  lib,
  pkgs,
  ...
}:
{

  networking.resolvconf.dnsExtensionMechanism = false;
  networking.resolvconf.dnsSingleRequest = true; # juste pour test
}
