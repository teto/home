{ config, pkgs, lib,  ... } @ args:
let
  secrets = import ./secrets.nix;
in
{
  i18n.inputMethod = "fcitx5";
  # programs.fcitx = {
  #   enable = true;
  # }
}
