{ pkgs, ... }:
{
  mujmap = {
    enable = true;
    verbose = true;

    package = pkgs.mujmap-unstable;
  };

  # let noctalia deal with it ?
  network-manager-applet.enable = true;
}
