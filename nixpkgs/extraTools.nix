{ pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    ncdu
#    udiskie
];
}
