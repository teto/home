{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    visidata

  ];

  programs.direnv.enable = true;

  programs.direnv.enableZshIntegration = true;

  # programs.direnv.config
  # programs.direnv.stdlib
}
