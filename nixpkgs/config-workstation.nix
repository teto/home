{ config, lib, pkgs, ... }:
{

  # workstation a plus d'espace disque donc on peut tester plus de trucs
  environment.systemPackages = [
    sway
    gnome3
  ];


}
