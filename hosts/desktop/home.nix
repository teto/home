# home-manager specific config from
{ config, lib, pkgs, ... }:
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
    ../../hm/profiles/android.nix
    ../../hm/profiles/desktop.nix
    ../../hm/profiles/polybar.nix
    ../../hm/profiles/sway.nix
    ../../hm/profiles/neomutt.nix
    ../../hm/profiles/nushell.nix
    ../../hm/profiles/mail.nix
    ../../hm/profiles/alot.nix
    # ../../hm/profiles/emacs.nix
    ../../hm/profiles/extra.nix
    # ../../hm/profiles/weechat.nix
    # ./profiles/vdirsyncer.nix

  ];

  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
  };

  # TODO generate a wrapper ?
  wayland.windowManager.sway = {
   	xwayland = true;
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];
    # export QT_QPA_PLATFORM=wayland
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    # export SDL_VIDEODRIVER=wayland
    # export XDG_CURRENT_DESKTOP="sway"
    # export XDG_SESSION_TYPE="wayland"
    # export _JAVA_AWT_WM_NONREPARENTING=1
    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
      # we need vulkan else we get flickering
      export WLR_RENDERER=vulkan
     '';

    # export GBM_BACKEND=nvidia-drm
    # export __GLX_VENDOR_LIBRARY_NAME=nvidia
  };

  # seulemt pour X
  programs.feh.enable = true;

  home.packages = with pkgs; [
    signal-desktop # installe a la main
    # gnome.gnome-maps
    xorg.xwininfo # for stylish
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

  # xrandr --output DVI-I-1 --primary
  # xsession.initExtra = ''
  # '';

}
