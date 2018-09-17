{ pkgs, lib,  ... }:
{
  imports = [
    ./home-common.nix
    ./home-desktop.nix

    ./home-mail.nix
  ];
  # home.keyboard.layout = "fr,us";

  home.packages = with pkgs; [
  ];

  home.file.".digrc".text = ''

    '';

  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    # must be a string
    path =  "/home/teto/home-manager";
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  # you can switch from cli with xkb-switch
  # or xkblayout-state
  # xev -event keyboard to retreive key symbols
  # xmodmap will show the modifiers list
  home.keyboard = {
    layout = "us,fr";
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    # TODO can add Mod4 
    options = [ 
      "add Mod1 Super_L"
      "keysym XF86Eject = Delete"
  ];
    # options = [ "add Mod1 Alt_R" ];
  };
}
