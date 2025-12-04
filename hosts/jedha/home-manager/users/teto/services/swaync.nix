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
    flakeSelf.homeProfiles.swaync.nix
  ];

  services.swaync = {
    enable = true;
  };

}
