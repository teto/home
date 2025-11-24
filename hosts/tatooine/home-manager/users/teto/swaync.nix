# sway notification center
{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    # flakeSelf.swaync
    ../../../hm/profiles/swaync.nix
  ];

  # TODO
  services.swaync = {
    enable = true;

  };
}
