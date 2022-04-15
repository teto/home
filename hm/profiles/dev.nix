{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    eva # calculette in a REPL
    dasht  # ~ zeal but in terminal
    visidata # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    graphviz
    # gitlab-runner
  ];

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
