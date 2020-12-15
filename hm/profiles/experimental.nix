{ pkgs, lib, config, ... }:
let

in

{
  # programs.meli = {
  #   enable = true;
  # };

  home.packages = with pkgs; [
    # rofi
    deadd-notification-center
    meli  # jmap mailreader
  ];
}
