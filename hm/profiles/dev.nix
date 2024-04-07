{ config, pkgs, lib, ... }:
{


  home.packages = with pkgs; [
    pciutils # for lspci
    gitAndTools.diff-so-fancy
	jq
    eva # calculette in a REPL
    # visidata # broken  # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    graphviz
    # linuxPackages.perf # to avoid kernel rebuild ?
    # filesystem watcher developed by facebook. Useful used in conjonction 
    # with core.monitorfs in git ()
    watchman
    vault
  ];

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
