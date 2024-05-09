{ config, pkgs, lib, ... }:
{
  imports = [
   ./flameshot.nix
  ];

 # TODO it is done in sway.nix
 # replaced with  package-sets.wayland
 package-sets.waylandPackages = true;
  # home.packages = with pkgs; [
  #   cliphist
  #   clipcat # rust

  #   # TODO test https://github.com/sentriz/cliphist
  #   foot # terminal
  #   # use it with $ grim -g "$(slurp)"
  #   grim # replace scrot/flameshot
  #   kanshi # autorandr-like
  #   kickoff # transparent launcher for wlr-root
  #   fuzzel  # rofi-like
  #   wofi # rofi-like
  #   slurp # capture tool
  #   # lavalauncher # TODO a tester
  #   wf-recorder # for screencasts
  #   # bemenu as a dmenu replacement
  #   wl-clipboard # wl-copy / wl-paste
  #   wdisplays # to show 
  #   swaybg # to set wallpaper
  #   swayimg # imageviewer
  #   swaynotificationcenter # top cool
  #   swaynag-battery # https://github.com/NixOS/nixpkgs/pull/175905
  #   sway-launcher-desktop # fzf-based launcher
  #   waypaper # sets wallpapers
  #   wlprop # like xprop, determines window parameters
  #   # swappy # e https://github.com/jtheoof/swappy
  #   # https://github.com/artemsen/swaykbdd # per window keyboard layout
  #   # wev # event viewer https://git.sr.ht/~sircmpwn/wev/
  #   wl-gammactl # to control gamma
  #   wlr-randr # like xrandr

  #   # wayprompt
  #   wev # equivalent of xev, to find the name of keys for instance
  #   wshowkeys
  # ];

}
