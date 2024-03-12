# could be called home-huge.nix
{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
  #   # lgogdownloader

    # gaming
    lutris
  ];

  # services.upower.percentageLow = 35;
  # services.upower.percentageCritical = 30;
  # services.upower.percentageAction = 25;
}
