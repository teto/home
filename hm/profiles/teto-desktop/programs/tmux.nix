{

  enable = true;
  aggressiveResize = false;

  baseIndex = 1;

  clock24 = true;
  # Override the hjkl and HJKL bindings for pane navigation and resizing in VI mode.
  # customPaneNavigationAndResize = true;
  # disableConfirmationPrompt
  historyLimit = 10000;
  focusEvents = false;

  mouse = true;

  # prefix = "C-q";
  # plugins =;

  # mouse on
  extraConfig = ''
    source-file ~/.config/tmux/manual.conf
  '';
}
