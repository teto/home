{ pkgs, lib, config, ... }:
let

in

{
  # programs.meli = {
  #   enable = true;
  # };

  programs.xdg.enable = true;

  home.packages = with pkgs; [
    deadd-notification-center
    meli  # broken jmap mailreader
  ];

  # programs.htop = {
  #   enabled = true;
  #   settings = {
  #     color_scheme = 5;
  #     delay = 15;
  #     highlight_base_name = 1;
  #     highlight_megabytes = 1;
  #     highlight_threads = 1;
  #   };
  # };
}
