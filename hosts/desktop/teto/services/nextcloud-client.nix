{
  pkgs,
  lib,
  config,
  ...
}:
{

  services.nextcloud-client.enable = true;
  # startInBackground
  home.packages = [
    pkgs.nextcloud-client
  ];

  systemd.user.services.nextcloud-client =
    lib.mkIf config.services.nextcloud-client.enable
      {
      };
  # libsForQt5.qt5.qtwayland
  # qt6.qtwayland
}
