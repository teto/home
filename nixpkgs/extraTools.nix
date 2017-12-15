{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    pciutils # for lspci
    ncdu  # to see disk usage
    bridge-utils # pour  brctl
#    udiskie
];
}
