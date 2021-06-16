{ config, pkgs, lib,  ... } @ args:
let
  secrets = import ./secrets.nix;
in
{

  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx5.addons = with pkgs.fcitx-engines;  [ mozc ];
    fcitx5.addons = with pkgs;  [ fcitx5-mozc ];
  };

  # i18n.inputMethod = "fcitx5";
  # programs.fcitx5 = {
  #   enable = true;
  #   # fcitx.engines = with pkgs.fcitx-engines; [

  #   addons = with pkgs.fcitx-engines; [
  #     mozc  # broken
  #     # table-other # for arabic
  #     # table-extra # for arabic
  #     # # hangul
  #     # m17n
  #   ];

  # };
}
