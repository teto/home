{ pkgs, ... }:
{
  mujmap = {
    enable = true;
    verbose = true;

    package = pkgs.mujmap-dev;
  };

  # nope !
  # audiocast.enable = false;

  # let noctalia deal with it ?
  network-manager-applet.enable = true;
}
