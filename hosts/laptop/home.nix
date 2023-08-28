# home-manager specific config from
{ config, lib, pkgs, ... }:
{

  imports = [
   ./sway.nix
   ./waybar.nix
   ../desktop/teto/home.nix
   ../desktop/teto/swaync.nix

    ../../hm/profiles/vdirsyncer.nix
    ../../hm/profiles/desktop.nix
    ../../hm/profiles/sway.nix
    ../../hm/profiles/waybar.nix
    # ../../hm/profiles/weechat.nix
    ../../hm/profiles/extra.nix
    ../../hm/profiles/syncthing.nix
    ../../hm/profiles/japanese.nix

    ../../hm/profiles/alot.nix
    ../../hm/profiles/dev.nix
    # ../../hm/profiles/vscode.nix #  provided by nova-nix config
    ../../hm/profiles/experimental.nix
    ../../hm/profiles/emacs.nix
  ];

  # dans le cadre de mon experimentation !
  home.packages = with pkgs; [
   timg
   lua
   imagemagick # for 'convert'
  ];

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = true;
}
