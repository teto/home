{ config, lib, pkgs, flakeSelf, ... }:
{
  imports = [
    flakeSelf.homeProfiles.teto-desktop
  ];

}
