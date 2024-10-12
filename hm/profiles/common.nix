{
  config,
  pkgs,
  lib,
  ...
}:
{
  news.display = "silent";

  imports = [

    ./bash.nix
    ./git.nix
    ./zsh.nix

    # the module is a pain
    # ./xdg-mime.nix
  ];

  xdg.mime.enable = true;

  programs.man.enable = true;

  # useful to prevent some problems with nix
  # https://github.com/commercialhaskell/stack/issues/2358
  # home.file.".stack/config.yaml".source = ../home/stack.yaml;

  xdg = {
    enable = true;
  };

  # you can switch from cli with xkb-switch or xkblayout-state
  # set to null to disable
  home.keyboard = {
    layout = "fr,us";
    # grp:alt_shift_toggle,ctrl:nocaps,grp_led:scroll
    options = [
      "add Mod1 Alt_R"
      "ctrl:nocaps" # makes caps lock an additionnal ctrl
    ];
  };

  # xdg-settings set default-web-browser firefox.desktop

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # so that fzf takes into account .gitignore
    defaultCommand = "${pkgs.fd}/bin/fd --type f";

    # add support for ctrl+o to open selected file in VS Code
    defaultOptions = [ "--bind='ctrl-o:execute(code {})+abort'" ];
    # Setting fd as the default source for fzf
    # defaultOptions
    # changeDirWidgetOptions
    # programs.fzf.fileWidgetOptions
    # programs.fzf.historyWidgetOptions
  };

  # for colors etc.
  programs.lesspipe.enable = false;

}
