# sway notification center
{
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [ ../../../hm/profiles/swaync.nix ];

  # TODO
  services.swaync = {
    enable = true;

  };
  # xdg.configFile."swaync/config.json" = lib.mkForce {};
  # xdg.configFile."swaync/config.json".enable = false;
}
