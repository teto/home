{ config, pkgs, lib,  ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "Ubuntu";
	# _ksi_preexec breaks my own preexec !
    shellIntegration.enable = false;
    settings = {

      bold_font  = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      font_size = 12;
      url_style = "curly";
      enable_audio_bell = false;
    };
    extraConfig = ''
      include ./manual.conf
    '';
  };
}
