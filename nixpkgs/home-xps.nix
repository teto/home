# home-manager specific config from
{ config, lib, pkgs,  ... }:
let

  mbsyncConfig = {
    enable = true;
    create = "maildir";
  };
  in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
      ./hm/desktop.nix
      ./hm/dev.nix

      # ./hm/experimental.nix
      # ./hm/vdirsyncer.nix
      ./hm/mail.nix
      ./hm/sway.nix

      # not merged yet
      # ./hm/autoUpgrade.nix

      ./hm/profiles/nova-user.nix
      ./hm/profiles/nova-dev.nix
    ]
    ;

  # depends from feh ? huh not if we use sway
  # programs.feh.enable = true;

  home.packages = with pkgs; [
    virt-manager # to run ubuntu, needs libvirtd service
    brightnessctl
    simple-scan
    # aqemu # 0.9.2 , needs kvm/qemu
    # kvm

  ];


  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    # must be a string
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

  # xrandr --output  eDP1 --mode 1600x900
  # xsession.initExtra = ''
  # '';

  # TODO try plugins
  # programs.vscode = {
  #   enable = true;
  #   haskell.enable = true;
  #   haskell.hie.enable = true;
  # };

}

