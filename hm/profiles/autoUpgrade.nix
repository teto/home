{
  config,
  pkgs,
  lib,
  ...
}:
{

  services.autoUpgrade = {
    enable = true;
  };
}
