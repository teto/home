{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mujmap = {
    enable = true;
    package = pkgs.mujmap-unstable;
  };
}
