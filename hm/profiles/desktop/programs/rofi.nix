{
  config,
  pkgs,
  lib,
  ...
}:
{

  enable = true;

  package = pkgs.rofi-wayland;

  terminal = "${pkgs.kitty}/bin/kitty";
  # borderWidth = 1;
  # theme = "solarized_alternate";
  # theme = "purple";
  # lines= ;
  location = "center";

  pass = {
    enable = true;
    extraConfig = ''
      # workaround for https://github.com/carnager/rofi-pass/issues/226
      help_color="#FF0000"'';
  };

  plugins = with pkgs; [
    rofi-emoji
    rofi-calc
    # passed as a flake now
    # rofi-hoogle # TODO see https://github.com/rebeccaskinner/rofi-hoogle/issues/3
  ];
  # pass.stores = [];

  # TODO use pywal ?
  theme = {
    "@import" = "${config.xdg.cacheHome}/wal/colors-rofi-dark.rasi";
    "@theme" = "purple";
  };

  # rofi.font: SourceCodePro 9
  # font =
  # ,Layouts:${../../bin/i3-list-layouts}
  extraConfig = {
    width = 50;
    columns = 1;
    matching = "fuzzy";
    show-icons = true;
    # ! cd window
    modi = "run,drun,window,ssh";
    # see to integrate teiler
    sidebar-mode = true;
    kb-row-up = "Up";
    kb-row-down = "Down";
    kb-mode-previous = "Alt+Left";
    kb-mode-next = "Alt+Right,Alt+Tab";
    kb-entry-history-up = "Control+p";
    kb-entry-history-down = "Control+n";
  };
}
