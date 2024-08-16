{
  config,
  pkgs,
  lib,
  ...
}@args:
{
  programs.mcfly = {
    enable = false; # disabled because it crashed
    keyScheme = "vim";
    enableZshIntegration = true;

  };
}
