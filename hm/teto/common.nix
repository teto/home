{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    # RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg.conf";
    # might be possible to remove
    INPUTRC = "$XDG_CONFIG_HOME/inputrc";

    # TODO package these instead now these are submoudles of dotfiles To remove
    # VIFM = "$XDG_CONFIG_HOME/vifm";
    # WWW_HOME = "$XDG_CONFIG_HOME/w3m";
    # used by ranger
    # TERMCMD = "kitty"; # xdg-terminal is better bow ?

  };
}
