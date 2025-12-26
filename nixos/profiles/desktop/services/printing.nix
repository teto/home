{ pkgs, ... }:
# Enable CUPS to print documents.
# https://nixos.wiki/wiki/Printing
{
  enable = true;
  browsing = true;
  drivers = [ pkgs.gutenprint ];
}
