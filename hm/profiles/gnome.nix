{
  config,
  lib,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome-calendar

  ];

  # experimental
  programs.gnome-shell = {
    enable = true;
    # without 'theme', it does not provide gnome-shell
    theme = {
      name = "Plata-Noir";
      package = pkgs.plata-theme;
    };
  };

  # see https://www.reddit.com/r/NixOS/comments/18hdool/how_do_i_set_a_global_dark_theme_and_configure_gtk/
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
