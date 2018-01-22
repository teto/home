{ config, lib, pkgs, ... }:
{
environment.systemPackages = with pkgs; [
    dex
    dunst
    # lgogdownloader
    # libreoffice # too long to compile
    libnotify # use via {pkgs.libnotify}/bin/notify-send
    gawk
    gksu
    # git-extras # does not find it (yet)
    gnome3.gnome_keyring
    gnome3.dconf # seems super important for dbus (https://github.com/NixOS/nixpkgs/issues/2448)
    gnum4 # hum
    gnupg
    libertine # font
    google-fonts
    mpv  # media player
    ncmpcpp
    networkmanager
    # networkmanager_l2tp
    networkmanagerapplet
    # neovim
    # pypi2nix # to convert
    pass
    qtpass
    ranger  # file explorer
    rofi  # very cool fuzzy searcher
    termite  # terminal for tile based WMs
    tmux
    vifm
    # vlc
    xorg.xmodmap
    # xauth # for 'startx'
    xclip
    xdg-user-dirs
    xcwd  # returns working directory of focused applications
    # xdg-utils
];
}
