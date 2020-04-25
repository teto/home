# could be called home-huge.nix
{ config, lib, pkgs,  ... }:
{

  home.packages = with pkgs; [
  # users.users.teto.packages = with pkgs; [
    hakuneko
    hexyl
    pinta    # photo editing
    pciutils # for lspci
    ncdu  # to see disk usage
    # bridge-utils # pour  brctl
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
    nodePackages.insect
    nushell  # rust-based semantic shell

    # a terminal slide
    # haskellPackages.patat
    # https://github.com/jaspervdj/patat
];

}
