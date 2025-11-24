{
  config,
  lib,
  pkgs,
  ...
}:
{
  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  # --loglevel debug
  systemd.user.services.blueman-applet.Service = {
    ExecStart = lib.mkForce "${pkgs.blueman}/bin/blueman-applet --loglevel debug";
  };
}
