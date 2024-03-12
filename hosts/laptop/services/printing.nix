{ pkgs, ... }:
{
  enable = true;
  browsing = true;
  drivers = [ pkgs.gutenprint ];
}
