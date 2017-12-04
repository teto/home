{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    ncdu
    bridge-utils # pour  brctl
#    udiskie
];
}
