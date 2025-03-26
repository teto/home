{
  config,
  pkgs,
  lib,
  ...
}:
{
  enable = true;
  # we need a monospace font
  # check that it supports italic with font-manager or
  # printf '\e[3mAB'
  # font.name = "Source Code Pro";
  # font.name = "Ubuntu";

  # _ksi_preexec breaks my own preexec !
  shellIntegration = {
    enableBashIntegration = false;
    enableZshIntegration = false;
    mode = null; # "enabled";
  };

  settings = {
    update_check_interval = 0; # set to 0 to disable (in hours)
    # bold_font = "auto";
    # italic_font = "auto";
    # bold_italic_font = "auto";
    confirm_os_window_close = 0;

    font_size = 12;
    url_style = "curly";
    enable_audio_bell = false;
  };
  extraConfig = ''
    include ./manual.conf
  '';
}
