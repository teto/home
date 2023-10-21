{ config, pkgs, options, lib, flakeInputs, ... }:
{
  programs.yazi = {
   enable = true;
   package = flakeInputs.yazi.packages.${pkgs.system}.yazi;
   };
 }


