{ config, pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    # colorSchmes = ;

    # _ksi_preexec breaks my own preexec !
    enableZshIntegration = true;
    # settings = {
    #   # bold_font = "auto";
    #   # italic_font = "auto";
    #   # bold_italic_font = "auto";
    #   font_size = 12;
    #   url_style = "curly";
    #   enable_audio_bell = false;
    # };

    # extraConfig = ''
    #   include ./manual.conf
    # '';
  };

  home.sessionVariables = {

    # for shell integration to work, https://github.com/wez/wezterm/issues/4406
    WEZTERM_SHELL_SKIP_ALL=1;
  };


  # for now test
  xdg.configFile."wezterm/wezterm.lua".enable = false;
}

