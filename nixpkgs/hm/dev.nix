{ config, pkgs, lib,  ... }:
{
  programs.direnv.enable = true;

  programs.direnv.enableZshIntegration = true;

  # programs.direnv.config
  # programs.direnv.stdlib
}
