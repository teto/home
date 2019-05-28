# home-manager specific config from
{ config, lib, pkgs,  ... }:
let 

  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';

    create = "maildir";
  };
  in
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
      # ./home-common-headless.nix
      ./home-desktop.nix

      ./modules/tablet.nix
      # ./modules/hm-experimental.nix
      ./modules/vdirsyncer.nix
      ./home-mail.nix
      # symlink towards a config
    ]
    ;

  # on home-manager master
  # home.accounts.mail.maildirModule
  programs.feh.enable = true;

  # add a service for tablet
  # https://github.com/ssmolkin1/i3touchmenu
  home.packages = with pkgs; [
    # touchegg # won't work anymore apparently
    # libinput-gestures
    # netperf # check for man; netserver to start

  ];

  # you can switch from cli with xkb-switch
  # or xkblayout-state
  home.keyboard = {
    # layout = "fr,us";
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    # TODO can add Mod4 
    # grp:alt_shift_toggle,ctrl:nocaps,grp_led:scroll
    options = [ "add Mod1 Alt_R" "ctrl:nocaps"];
    # options = [ "add Mod1 Alt_R" ];
  };

  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    # must be a string
    path =  "/home/teto/home-manager";
  };
  
  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  # programs.bash = {
  #   # goes to .profile
  #   sessionVariables = {
  #     # HISTFILE="$XDG_CACHE_HOME/bash_history";
  #   };
  # };

  services.nextcloud-client.enable = true;

  programs.termite = {
    enable = true;
    # TODO the light in fact
    colorsExtra = builtins.readFile ../config/termite/solarized-dark;
  };

  xsession.initExtra = ''
    xrandr --output  eDP1 --mode 1600x900
  '';

  # programs.vscode = {
  #   enable = true;
  #   haskell.enable = true;
  #   haskell.hie.enable = true;
  # };
    # xrandr --output  eDP1 --mode 1600x900
  # '';


}

