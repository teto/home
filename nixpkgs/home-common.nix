# home-manager specific config from
{ config, lib, touchegg, ... }:
{
  imports = [
      ./basetools.nix
      ./extraTools.nix
      ./desktopPkgs.nix
      ];


}

