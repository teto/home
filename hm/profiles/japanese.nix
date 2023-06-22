{ config, pkgs, lib, flakeInputs, ... }:
{
  home.packages = with pkgs; [
    tagainijisho # japanse dict; like zkanji Qt based
    # ${config.system}
    flakeInputs.vocage.packages."x86_64-linux".vocage


  ];


}
