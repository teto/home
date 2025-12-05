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
    flakeSelf.homeProfiles.swaync
  ];

  services.swaync = {
    enable = true;
  };

}
