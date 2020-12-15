# home-manager specific config from
{ config, lib, pkgs,  ... }:
let
  # nova-nix = builtins.getFlake "/home/teto/nova/nova-nix"
in
{
  # invalid with flakes  nixpkgs.config.allowUnfree = true;

  imports = [
      ./hm/desktop.nix
      ./hm/dev.nix
      ./hm/nova.nix

      # ./hm/vdirsyncer.nix
      # ./hm/nushell.nix
      ./hm/mail.nix
      ./hm/sway.nix

      # not merged yet
      # ./hm/autoUpgrade.nix
  ];

  # depends from feh ? huh not if we use sway
  # programs.feh.enable = true;

  home.packages = with pkgs; [
    virt-manager # to run ubuntu, needs libvirtd service
    brightnessctl
    simple-scan
  ];


  programs.home-manager = {
    enable = true;
    path =  "/home/teto/home-manager";
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  services.nextcloud-client.enable = true;

# waiting for attribute 'vte-ng' missing
  programs.termite = {
    enable = false;
    # TODO the light in fact
    # check if it exists
    # colorsExtra = builtins.readFile ../config/termite/solarized-dark;
  };

}

