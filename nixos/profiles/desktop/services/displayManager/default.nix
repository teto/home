/*
  Summary of login process (since i am afraid to forget about it):

  1. systemd launches default.target, which on nixos starts display-manager.service
  2. on login, the system launches the user default.target (via pam_systemd / logind ?)
  3. the display manager usually finds sessions in share/wayland-sessions, a folder containing .desktop files. For instance it contains a sway.desktop which launches sway (hopefully the wrapped version).
  The generated sway config should execute a "dbus-update-activation-environment" call that imports WAYLAND_DISPLAY into the user environment

  A bunch of systemd services are waiting for WAYLAND_DISPLAY to be set (ConditionEnvironment)
*/
{
  config,
  lib,
  pkgs,
  ...
}:

{
  logToFile = true;

  # services.displayManager.ly.enable = true;

  # lemurs = ;

  # ly.enable = true;
  # see displayManager.nix instead
  # gdm.enable = true;

}
