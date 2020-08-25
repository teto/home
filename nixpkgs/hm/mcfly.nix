{ config, pkgs, lib,  ... } @ args:
{
  programs.mcfly = {
    enable = true;
    keyScheme = "vim";
    enableZshIntegration = true;

  };
}
