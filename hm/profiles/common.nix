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
    ./teto-zsh.nix
  ];

  programs.man.enable = true;

  # useful to prevent some problems with nix
  # https://github.com/commercialhaskell/stack/issues/2358
  # home.file.".stack/config.yaml".source = ../home/stack.yaml;

  xdg = {
    enable = true;
    mime.enable = true;
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

  # for colors etc.
  programs.lesspipe.enable = false;

}
