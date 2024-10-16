{
  config,
  lib,
  pkgs,
  ...
}:
{
  user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    # export XDG_SESSION_TYPE=wayland
    # export QT_QPA_PLATFORM=wayland
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

  };
  # settings.Manager.DefaultEnvironment
}
