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
      # ./modules/vdirsyncer.nix
      # ./modules/sway.nix
      ./neomutt.nix

      ./home-mail.nix
      ./home-extra.nix
      # symlink towards a config
  ]
  ;

  # on home-manager master
  # home.accounts.mail.maildirModule
  programs.feh.enable = true;

  home.packages = with pkgs; [
    # touchegg # won't work anymore apparently
    # libinput-gestures
    # rofi
    # netperf # check for man; netserver to start
    # nushell
    steam-run
  ];


  # hum...
  # services.lorri.enable = true;

  # you can switch from cli with xkb-switch
  # or xkblayout-state
  home.keyboard = {
    # layout = "fr,us";
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    # TODO can add Mod4 
    options = [ "add Mod1 Alt_R" ];
    # options = [ "add Mod1 Alt_R" ];
  };

  programs.home-manager = {
    enable = true;
    # must be a string
    path =  "/home/teto/home-manager";
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = false;

  # programs.bash = {
  #   # goes to .profile
  #   sessionVariables = {
  #     # HISTFILE="$XDG_CACHE_HOME/bash_history";
  #   };
  # };

  services.nextcloud-client.enable = true;

  home.sessionVariables = {
    DASHT_DOCSETS_DIR="/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

  xsession.initExtra = ''
    xrandr --output DVI-I-1 --primary
  '';

  # fzf-extras found in overlay fzf-extras
  programs.zsh.initExtra = ''
  '';

}

