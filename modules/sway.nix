{ config, lib, pkgs, ... }:
{
  # https://github.com/rycee/home-manager/pull/829
  # https://discourse.nixos.org/t/sway-nixos-home-manager-conflict/20760/10
  programs.sway.enable = true;
  programs.sway.package = null;
}
