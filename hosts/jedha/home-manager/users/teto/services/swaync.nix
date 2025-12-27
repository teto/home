# sway notification center
{
  config,
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.homeProfiles.sway-notification-center
  ];

  services.swaync = {
    enable = true;
  };

}
