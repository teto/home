# home-manager specific config from
{ config, lib, pkgs, ... }:
{

  imports = [
   # borken
    ../../hm/profiles/vdirsyncer.nix
    # ../../hm/nushell.nix
    ../../hm/profiles/desktop.nix
    ../../hm/profiles/mail.nix
    ../../hm/profiles/sway.nix
    # ../../hm/profiles/weechat.nix
    ../../hm/profiles/extra.nix
    ../../hm/profiles/syncthing.nix
    ../../hm/profiles/japanese.nix

    ../../hm/profiles/alot.nix
    ../../hm/profiles/dev.nix
    ../../hm/profiles/vscode.nix #  provided by nova-nix config
    ../../hm/profiles/experimental.nix
    ../../hm/profiles/emacs.nix
    ../../hm/profiles/wayland.nix

    # not merged yet
    # ./hm/autoUpgrade.nix
  ];

  # use a release version
  # programs.neovim.package = lib.mkForce pkgs.neovim;

  xsession.windowManager.i3 = {
    # enable = false;
  };

  wayland.windowManager.sway = {
    enable = true;

    extraOptions = [
      "--verbose"
      "--debug"
    ];
  };
  programs.waybar = {
   settings = {
     mainBar = {
       modules-right = [ 
        "battery"
        "bluetooth"
        # "backlight"
       ];
       battery = {

        format = "{time} {icon}";
       };
    };
    };
  };

  home.packages = with pkgs; [
    hlint # (for test with manpage)
    brightnessctl
    # simple-scan
  ];

  services.screen-locker = {
    enable = false;
    inactiveInterval = 5; # in minutes
    lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    # xssLockExtraOptions
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  services.nextcloud-client.enable = true;
}
