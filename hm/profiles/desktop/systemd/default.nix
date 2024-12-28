{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
}:
{
  # ~/.config/environment.d/10-home-manager.conf
  user.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # SetLoginEnvironment=no
  };

  user.settings.Manager.DefaultEnvironment = {
    # when use-xdg-directories is true, the bin is in $XDG_STATE_HOME/
    # PATH= "${dotfilesPath}/bin";
    PATH = "/home/teto/.local/state/nix/profile/bin;${dotfilesPath}/bin";
    # /home/teto/.nix-profile/bin:/nix/profile/bin:/home/teto/.local/state/nix/profile/bin:/etc/profiles/per-user/teto/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/teto/.local/share/../bin
  };

  # systemd.user.settings
  #     Extra config options for user session service manager. See systemd-user.conf(5) for available options.

  # settings.Manager.DefaultEnvironment
}
