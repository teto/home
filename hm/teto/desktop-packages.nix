{ config, lib, pkgs, ... }:
{
 home.packages = with pkgs; [
    nix-output-monitor
  ];
}
