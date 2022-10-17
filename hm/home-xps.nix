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
      ./profiles/alot.nix
      ./profiles/mail.nix
      ./profiles/sway.nix
      ./profiles/weechat.nix
      ./profiles/extra.nix
      ./profiles/syncthing.nix
      ./profiles/japanese.nix

      # not merged yet
      # ./hm/autoUpgrade.nix
  ];

  # use a release version
  programs.neovim.package = lib.mkForce pkgs.neovim;

  xsession.windowManager.i3 = {
    # enable = false;
  };

  wayland.windowManager.sway= {
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
