{ config, pkgs, lib, ... }:
let
  # rofi-hoogle-src = pkgs.fetchFromGitHub {
  #   owner = "teto";
  #   repo = "rofi-hoogle";
  #   rev = "27c273ff67add68578052a13f560a08c12fa5767";
  #   sha256 = "09vx9bc8s53c575haalcqkdwy44ys1j8v9k2aaly7lndr19spp8f";
  # };

  # TODO need hs-hoogle-overlay
  # rofi-hoogle = import "${rofi-hoogle-src}/rofi-hoogle-plugin/package.nix" { inherit pkgs; };
  #   hs-hoogle-query = pkgs.haskellPackages.callPackage "${rofi-hoogle-src}/haskell" {};

  #
in
{
  programs.rofi = {
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
      /* see to integrate teiler */
      sidebar-mode = true;
      kb-mode-previous = "Alt+Left";
      kb-mode-next = "Alt+Right,Alt+Tab";
	  kb-entry-history-up = "Control+p";
	  kb-entry-history-down = "Control+n";
    };
  };
}
