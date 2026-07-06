{
  pkgs,
  flakeSelf,
  ...
}:
{
  _imports = [
    flakeSelf.homeProfiles.tmux
  ];

  enable = true;
  aggressiveResize = false;

  shortcut = "a";
  disableConfirmationPrompt = true;
  sensibleOnTop = true;
  baseIndex = 1;

  keyMode = "vi";
  customPaneNavigationAndResize = true;

  clock24 = true;
  # Override the hjkl and HJKL bindings for pane navigation and resizing in VI mode.
  # customPaneNavigationAndResize = true;
  # disableConfirmationPrompt
  historyLimit = 10000;
  focusEvents = true;

  mouse = true;

  # prefix = "C-q";
  plugins = [
    pkgs.tmuxPlugins.cpu
  ];

  # mouse on
  extraConfig = ''
    source-file ~/.config/tmux/manual.conf
  '';
}
