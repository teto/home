{ pkgs, lib, config, ... }:
let

in

{
  # programs.meli = {
  #   enable = true;
  # };

  programs.fcitx5.enable = true;
  # programs.xdg.enable = true;

  home.packages = with pkgs; [
    # rofi
    deadd-notification-center
    meli  # jmap mailreader
  ];
}
