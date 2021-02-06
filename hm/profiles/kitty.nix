{ config, pkgs, lib,  ... }:
{
  programs.kitty = {
    font.name = "Inconsolata For Powerline 11";
    settings = {

      bold_font  = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      font_size = 13.0;
    };
    extraConfig = ''
      include "manual.conf"
    '';
  };
}
