{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [

    # TODO try i3-snapshot
    # hstr # to deal with shell history
    # or lazygit
    nix-prefetch-git
    netcat-gnu # plain 'netcat' is the bsd one
    # nvimpager # 'less' but with neovim
    strace
    tailspin  #  a log viewer based on less ("spin" or "tsspin" is the executable)
    tig
    tree
  ];

  home.sessionVariables = {
    # RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/rg.conf";
    INPUTRC = "$XDG_CONFIG_HOME/inputrc";

    # TODO package these instead now these are submoudles of dotfiles To remove
    # VIFM = "$XDG_CONFIG_HOME/vifm";
    # WWW_HOME = "$XDG_CONFIG_HOME/w3m";
    # used by ranger
    TERMCMD = "kitty"; # xdg-terminal is better bow ?

  };
}
