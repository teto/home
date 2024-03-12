{ config, pkgs, lib, ... }:
{


  home.packages = with pkgs; [
    pciutils # for lspci
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
	jq
    eva # calculette in a REPL
    dasht # ~ zeal but in terminal
    # visidata # broken  # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    graphviz
    nil # nix LSP server, so that vscode can see it
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
