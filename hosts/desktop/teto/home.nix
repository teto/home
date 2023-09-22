# home-manager specific config from
{ config, lib, flakeInputs
, pkgs
, withSecrets
, ... }:
{
  imports = [
    ./bash.nix
    ./calendars.nix
    ./git.nix
    ./neovim.nix
    ./ssh-config.nix
    ./sway.nix
    ./swaync.nix
    ./zsh.nix
    ./yazi.nix

    # Not tracked, so doesn't need to go in per-machine subdir
    ../../../hm/profiles/android.nix
    ../../../hm/profiles/desktop.nix
    ../../../hm/profiles/sway.nix
    ../../../hm/profiles/waybar.nix
    ../../../hm/profiles/neomutt.nix
    ../../../hm/profiles/nushell.nix
    ../../../hm/profiles/alot.nix
    ../../../hm/profiles/extra.nix
    ../../../hm/profiles/vdirsyncer.nix
    # ../../../hm/profiles/experimental.nix
    ../../../hm/profiles/japanese.nix
    ../../../hm/profiles/fcitx.nix
    ../../../hm/profiles/nova.nix
    ../../../hm/profiles/vscode.nix
    ../../../hm/profiles/extra.nix
      # custom modules
      ../../../hm/profiles/nova.nix
    # ../../hm/profiles/emacs.nix
    # ../../hm/profiles/weechat.nix

   ] ++ lib.optionals withSecrets [
    ./mail.nix
   ]
;

  programs.helix.enable = true;

  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };

  # xsession.windowManager.i3 = {
  #   enable = true;
  # };


  # seulemt pour X
  # programs.feh.enable = true;

  home.packages = with pkgs; [
    # signal-desktop # installe a la main
    # gnome.gnome-maps
    # xorg.xwininfo # for stylish
    pciutils # for lspci
    ncdu # to see disk usage
    moar # test as pager
    # bridge-utils# pour  brctl
  ];

  # you can switch from cli with xkb-switch or xkblayout-state
  home.keyboard = {
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    options = [ "add Mod1 Alt_R" ];
  };

  # for blue tooth applet; must be installed systemwide
  # services.blueman-applet.enable = false;

  services.nextcloud-client.enable = true;

  home.sessionVariables = {
   # TODO create symlink ?
    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

  home.stateVersion = "23.05";

  # xrandr --output DVI-I-1 --primary
  # xsession.initExtra = ''
  # '';

}
