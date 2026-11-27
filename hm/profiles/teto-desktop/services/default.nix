{ pkgs, ... }:
{
  mujmap = {
    enable = true;
    verbose = true;

    package = pkgs.mujmap-dev;
  };

  # nope !
  # audiocast.enable = false;

  # noctalia talks to networkmanager over dbus, it works better than the buggy applet
  # network-manager-applet.enable = true;
}
