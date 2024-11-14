{
  config,
  lib,
  pkgs,
  ...
}:
{
  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;
}
