{
  enable = true;
  sensibleOnTop = true;
  # secureSocket = false;
  # tmuxinator.enable = false;
  # tmuxp

  # see if we can't get https://github.com/tmux-plugins/vim-tmux-focus-events in
  # plugins = with pkgs; [
  #              tmuxPlugins.cpu
  #              {
  #                plugin = tmuxPlugins.resurrect;
  #                extraConfig = "set -g @resurrect-strategy-nvim 'session'";
  #              }
  #              {
  #                plugin = tmuxPlugins.continuum;
  #                extraConfig = ''
  #                  set -g @continuum-restore 'on'
  #                  set -g @continuum-save-interval '60' # minutes
  #                '';
  #              }
  #            ];

  extraConfig = ''
    # ----------------------
    # Status Bar
    # -----------------------
    set-option -g status on                # turn the status bar on
    if-shell -b 'head $XDG_CONFIG_HOME/tmux/config' \
      "source-file $XDG_CONFIG_HOME/tmux/config"
  '';
}
