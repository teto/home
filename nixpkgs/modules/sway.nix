{ config, lib, pkgs,  ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  programs.sway.enable = true;

  # adding sway-specific packages
  home.packages = with pkgs; [
    mako
    wofi
  ];
}
