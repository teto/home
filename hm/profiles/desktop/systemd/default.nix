{
  config,
  lib,
  pkgs,
  ...
}:
{
  # ~/.config/environment.d/10-home-manager.conf
  user.sessionVariables = {
    QT_QPA_PLATFORM="wayland";
    XDG_SESSION_TYPE="wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # SetLoginEnvironment=no
  };

       # systemd.user.settings
       #     Extra config options for user session service manager. See systemd-user.conf(5) for available options.

  # settings.Manager.DefaultEnvironment
}
