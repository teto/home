# home-manager specific config from
{ config, lib, pkgs, ... }:
{

  imports = [
   # borken
    ../../hm/profiles/vdirsyncer.nix
    ../../hm/profiles/desktop.nix
    ../../hm/profiles/mail.nix
    ../../hm/profiles/sway.nix
    # ../../hm/profiles/weechat.nix
    ../../hm/profiles/extra.nix
    ../../hm/profiles/syncthing.nix
    ../../hm/profiles/japanese.nix

    ../../hm/profiles/alot.nix
    ../../hm/profiles/dev.nix
    # ../../hm/profiles/vscode.nix #  provided by nova-nix config
    ../../hm/profiles/experimental.nix
    ../../hm/profiles/emacs.nix
    ../../hm/profiles/wayland.nix

  ];


  wayland.windowManager.sway = {
    enable = true;

    extraOptions = [
      "--verbose"
      "--debug"
    ];
  };

  home.packages = with pkgs; [
    hlint # (for test with manpage)
    brightnessctl
    # simple-scan
  ];


  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;

  services.nextcloud-client.enable = true;
}
