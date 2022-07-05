# home-manager specific config from
{ config, lib, pkgs,  ... }:
let

in
{
  imports = [
    # Not tracked, so doesn't need to go in per-machine subdir
      ./profiles/desktop.nix
      # ./profiles/vdirsyncer.nix
      ./profiles/polybar.nix
      ./profiles/sway.nix
      ./profiles/neomutt.nix
      ./profiles/nushell.nix
      # ./hm/profiles/nova-dev.nix
      ./profiles/mail.nix
      ./profiles/alot.nix
      ./profiles/emacs.nix
      ./profiles/extra.nix
      ./profiles/weechat.nix
  ];


  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };

  xsession.windowManager.i3 = {
    enable = true;
  };
  wayland.windowManager.sway = {
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];
    extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export SDL_VIDEODRIVER=wayland
        export XDG_CURRENT_DESKTOP="sway"
        export XDG_SESSION_TYPE="wayland"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export GBM_BACKEND=nvidia-drm
        export GBM_BACKENDS_PATH=/etc/gbm
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export WLR_NO_HARDWARE_CURSORS=1
      ''; 
  };

  # seulemt pour X
  programs.feh.enable = true;

  home.packages = with pkgs; [
    # steam-run
    signal-desktop
    lutris
    xorg.xwininfo # for stylish
  ];

  # hum...
  # services.lorri.enable = true;

  # you can switch from cli with xkb-switch or xkblayout-state
  home.keyboard = {
    # options = [ "grp:caps_toggle" "grp_led:scroll" ];
    options = [ "add Mod1 Alt_R" ];
  };

  # for blue tooth applet; must be installed systemwide
  # services.blueman-applet.enable = false;

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
