# could be called home-huge.nix
{ config, lib, pkgs,  ... }:
{

  users.users.teto.packages = with pkgs; [
    pciutils # for lspci
    ncdu  # to see disk usage
    bridge-utils # pour  brctl
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
    nodePackages.insect
    nushell  # rust-based semantic shell
];

}
