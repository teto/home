{ config, lib, pkgs,  ... }:
{
  # https://github.com/rycee/home-manager/pull/829

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;

    # config = removeAttrs  config.xsession.windowManager.i3.config ["startup"];
  };

  home.packages = with pkgs; [
    # grimshot # simplifies usage of grim ?
    clipman  # clipboard manager
    grim  # replace scrot
    kanshi  # autorandr-like
    wofi  # rofi-like
    slurp  # capture tool
    # wf-recorder # for screencasts
    # bemenu as a dmenu replacement
    wl-clipboard # wl-copy / wl-paste
  ];

  programs.mako = {
    enable = true;
  };
}
