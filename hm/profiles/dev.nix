{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    visidata
    gitAndTools.pass-git-helper
     graphviz
  ];

  programs.direnv.enable = true;

  programs.direnv.enableZshIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  # programs.direnv.config
  # programs.direnv.stdlib
}
