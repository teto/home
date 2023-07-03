{ config, pkgs, lib, ... }:
{


  home.packages = with pkgs; [
    pciutils # for lspci
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
	jq
    eva # calculette in a REPL
    dasht # ~ zeal but in terminal
    # visidata # broken  # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    graphviz
    flamegraph
    nil # nix LSP server, so that vscode can see it
    # linuxPackages.perf # to avoid kernel rebuild ?
    # filesystem watcher developed by facebook. Useful used in conjonction 
    # with core.monitorfs in git ()
    watchman
    # gitlab-runner
    vault
  ];

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
