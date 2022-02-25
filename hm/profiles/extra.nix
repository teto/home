# could be called home-huge.nix
{ config, lib, pkgs,  ... }:
{
  programs.pywal.enable = true;

  services.opensnitch-ui.enable = true;

  home.packages = with pkgs; [
    hakuneko
    hexyl
    pinta    # photo editing
    pciutils # for lspci
    bridge-utils # pour  brctl
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
    nodePackages.insect  # fancy calculator
    # nushell  # rust-based semantic shell
    # tlaplus  # formal logic
    # tlaplusToolbox  # from leslie lamport

    # a terminal slide
    # haskellPackages.patat
    # https://github.com/jaspervdj/patat
];

}
