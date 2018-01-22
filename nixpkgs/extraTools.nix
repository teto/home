{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    pciutils # for lspci
    ncdu  # to see disk usage
    bridge-utils # pour  brctl
    wirelesstools # to get iwconfig
    gitAndTools.diff-so-fancy
    # aircrack-ng
#    udiskie
];
}
