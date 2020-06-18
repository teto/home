{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    visidata
    yaml-language-server
    # dockerfile-language-server-nodejs
  ];

  programs.direnv.enable = true;

  programs.direnv.enableZshIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  # programs.direnv.config
  # programs.direnv.stdlib
}
