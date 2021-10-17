{ config, pkgs, lib,  ... }:
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    # borderWidth = 1;
    # theme = "solarized_alternate";
    # lines= ;
    location = "center";
    pass.enable = true;

    # pass.stores = [];

    # rofi.font: SourceCodePro 9
    # font =
    # ,Layouts:${../../bin/i3-list-layouts}
    extraConfig={
      width = 50;
      columns= 1;
      matching = "fuzzy";
      show-icons = true;
      # ! cd window
      modi =       "run,drun,window,ssh";
      /* see to integrate teiler */
      sidebar-mode= true;
      kb-mode-previous = "Alt+Left";
      kb-mode-next =	"Alt+Right,Alt+Tab";
    };
  };
}
