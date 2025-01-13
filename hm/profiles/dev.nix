{
  config,
  pkgs,
  lib,
  ...
}:
{

  home.packages = with pkgs; [
    visidata # broken  # "vd", spreadsheet in terminal
    gitAndTools.pass-git-helper # to register docker password in terminal
    # linuxPackages.perf # to avoid kernel rebuild ?
    # filesystem watcher developed by facebook. Useful used in conjonction
    # with core.monitorfs in git ()
    # watchman
    vault
  ];

  # packages-sets = {
  # };

  programs.direnv = {
    enable = true;

    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
