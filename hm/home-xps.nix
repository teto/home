# home-manager specific config from
{ config, lib, pkgs,  ... }:
let
in
{

  imports = [
      ./profiles/desktop.nix
      ./profiles/dev.nix

      # ./hm/vdirsyncer.nix
      # ./hm/nushell.nix
      ./profiles/mail.nix
      ./profiles/sway.nix
      ./profiles/weechat.nix
      ./profiles/extra.nix
      ./profiles/syncthing.nix

      # not merged yet
      # ./hm/autoUpgrade.nix
  ];

  xsession.windowManager.i3 = {
    enable = true;
  };
  wayland.windowManager.sway.enable = true;
  # depends from feh ? huh not if we use sway
  # programs.feh.enable = true;

  wayland.windowManager.sway.extraOptions = [
    "--verbose"
    "--debug"
  ];

  home.packages = with pkgs; [
    brightnessctl
    simple-scan
  ];

  services.screen-locker = {
    enable = false;
    inactiveInterval = 5; # in minutes
    lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    # xssLockExtraOptions
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  # services.nextcloud-client.enable = true;

# waiting for attribute 'vte-ng' missing
  programs.termite = {
    enable = false;
    # TODO the light in fact
    # check if it exists
    # colorsExtra = builtins.readFile ../config/termite/solarized-dark;
  };

}
