{
  config,
  pkgs,
  flakeSelf,
  lib,
  ...
}:
{

  enable = true;

  # package = pkgs.rofi-wayland;
  package = pkgs.rofi-teto;

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
  # pass.stores = [];

  plugins = with pkgs; [
    rofi-emoji
    rofi-calc
    # passed as a flake now
    # flakeSelf.inputs.rofi-hoogle.packages.${pkgs.stdenv.hostPlatform.system}.rofi-hoogle # TODO see https://github.com/rebeccaskinner/rofi-hoogle/issues/3
  ];

  # I should be able to add more modes
  # Layouts:${../../bin/i3-list-layouts}
  # - "displays"
  # - premade targets such as checking out mails
  # - load sway layouts
  # - trigger a nixos rebuild ?
  # - start services ?
  # - powermenu
  modes = [
    # modes: [ combi ];
    # combi-modes: [ window, drun, run ];

  ];

  # TODO use walllust's '~/.cache/wallust/colors.rasi'
  # theme = "${config.xdg.cacheHome}/wallust/colors.rasi";
  # purple or material
  # theme = "";

  # -drun-match-fields
  # -plugin-path
  extraConfig = {

    # If you disable sorting and history is enabled, then the most used should show up more to the top.
    # available: normal, regex, glob, fuzzy, prefix
    matching = "fuzzy";

    # or "fzf"
    # sorting-method = "levenshtein" ;
    sorting-method = "fzf";

    width = 50;
    columns = 1;
    show-icons = true;
    # ! cd window
    modi = "run,drun,window,ssh";
    combi-modes = [
      "window"
      "drun"
    ];
    # see to integrate teiler
    sidebar-mode = true;
    kb-row-up = "Up";
    kb-row-down = "Down";
    kb-mode-previous = "Alt+Left";
    kb-mode-next = "Alt+Right,Alt+Tab";
    kb-entry-history-up = "Control+p";
    kb-entry-history-down = "Control+n";
  };

  # extraConfig = {
  #
  #   "?import" = "manual.rasi";
  # };
}
