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

  # when use-xdg-directories is true, the bin is in $XDG_STATE_HOME/
  # PATH= "${dotfilesPath}/bin";
  # /home/teto/.local/state/nix/profile/bin

  # systemctl --user show-environment to check value
  user.settings.Manager.DefaultEnvironment = {
    # c'est transforme en PATH=$'$PATH:/home/teto/.local/state/nix/profile/bin:/home/teto/home/bin' bizarrement
    # TODO add coreutils

    # settings.Manager.DefaultEnvironment
    # prefixing with '$PATH:' generates:
    # PATH=$'$PATH:/home/teto/.local/state/nix/profile/bin:/nix/store/4s9rah4cwaxflicsk5cndnknqlk9n4p3-coreutils-9.5/bin:/home/teto/home/bin'
    # which is odd ?
    PATH = "/home/teto/.local/state/nix/profile/bin:${pkgs.coreutils}/bin:${dotfilesPath}/bin";
  };

  # systemd.user.settings
  #     Extra config options for user session service manager. See systemd-user.conf(5) for available options.
}
