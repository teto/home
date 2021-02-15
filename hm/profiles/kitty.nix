{ config, pkgs, lib,  ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "Inconsolata For Powerline 11";
    settings = {

      bold_font  = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      font_size = 12;
      url_style = "curly";

    };
    extraConfig = ''
      include "manual.conf"
    '';
  };
}
