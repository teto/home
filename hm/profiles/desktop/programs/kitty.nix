{
  config,
  pkgs,
  lib,
  ...
}:
{
  # programs.kitty = {
  enable = true;
  # we need a monospace font
  # check that it supports italic with font-manager or 
  # printf '\e[3mAB'
  # font.name = "Source Code Pro";
  # font.name = "Ubuntu";

  # _ksi_preexec breaks my own preexec !
  shellIntegration = {
    enableZshIntegration = true;
    mode = "enabled";
  };
  settings = {

    # bold_font = "auto";
    # italic_font = "auto";
    # bold_italic_font = "auto";

    font_size = 12;
    url_style = "curly";
    enable_audio_bell = false;
  };
  extraConfig = ''
    include ./manual.conf
  '';
  # };
}
