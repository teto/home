{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    visidata
    gitAndTools.pass-git-helper
    graphviz
    gitlab-runner
  ];

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  # stdlib
  };
}
