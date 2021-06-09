# home-manager specific config from
{ config, lib, pkgs,  ... }:
let

in
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
      ./profiles/desktop.nix
      # ./modules/vdirsyncer.nix
      ./profiles/sway.nix
      ./profiles/neomutt.nix
      # ./hm/profiles/nova-dev.nix
      ./profiles/mail.nix
      ./profiles/alot.nix
      ./profiles/extra.nix
      ./profiles/weechat.nix
  ];


  programs.pazi = {
    enable = true;
    enableZshIntegration = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
  };
  wayland.windowManager.sway.extraOptions = [
    "--verbose" "--debug" "--unsupported-gpu" "--my-next-gpu-wont-be-nvidia"
  ];
  programs.feh.enable = true;

  home.packages = with pkgs; [
    # steam-run
  ];

  # hum...
  # services.lorri.enable = true;

  # you can switch from cli with xkb-switch or xkblayout-state
  home.keyboard = {
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    options = [ "add Mod1 Alt_R" ];
  };

  # for blue tooth applet; must be installed systemwide
  services.blueman-applet.enable = false;

  services.nextcloud-client.enable = true;

  home.sessionVariables = {
    DASHT_DOCSETS_DIR="/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

  # xrandr --output DVI-I-1 --primary
  xsession.initExtra = ''
  '';

  # fzf-extras found in overlay fzf-extras
  # programs.zsh.initExtra = ''
  # '';
}
