{ config, pkgs, lib,  ... }:
{


  home.packages = with pkgs; [
    eva # calculette in a REPL
    dasht  # ~ zeal but in terminal
    visidata # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    graphviz
	flamegraph
	linuxPackages.perf
	# filesystem watcher developed by facebook. Useful used in conjonction 
	# with core.monitorfs in git ()
	watchman 
    # gitlab-runner
  ];

  programs.direnv = {
    enable = false;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
