# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  ...
}:
{

  imports = [
    # flakeSelf.homeModules.bash

    flakeSelf.homeProfiles.qutebrowser
    flakeSelf.inputs.nix-index-database.homeModules.nix-index

    flakeSelf.homeModules.teto-nogui
    flakeSelf.homeModules.experimental
    flakeSelf.homeProfiles.wezterm
    # flakeSelf.homeModules.gnome-shell

    ./calendars.nix
    ./sway.nix
    ./systemd.nix

    ./programs/neovim.nix
    ./programs/waybar.nix # TODO resotre ?
    ./programs/zsh.nix

    ./services/local-ai.nix
    ./services/ollama.nix
    ./services/kanshi.nix
    ./services/ssh-agent.nix
    ./services/swaync.nix
    ./services/mpd.nix
    ./services/mpris.nix
    ./services/wpaperd.nix
  ]
  ++ lib.optionals withSecrets [
    ./sops.nix
    ./ia.nix
    # ../../../../../hm/profiles/nushell.nix
  ];

  # services.opensnitch-ui.enable

  # TODO use mkSymlinkOufOf  ? ?
  # xdg.configFile."zsh/zshrc.generated".source = ../../../config/zsh/zshrc;

  # programs.nh.enable = true;

  # never tried
  # home.preferXdgDirectories = false;

  home.file.".gdbinit".text = ''
    # ../config/gdbinit_simple;
    # gdb doesn't accept environment variable except via python
    source ${config.xdg.configHome}/gdb/gdbinit_simple
    set history filename ${config.xdg.cacheHome}/gdb_history
  '';

  # for programs not merged yet
  home.packages =
    with pkgs;
    [
      # llm-ls # needed by the neovim plugin

      cointop # bitcoin tracker
      # mdp # markdown CLI presenter
      # gthumb # image manager, great to tag pictures
      gnome-control-center
      gnome-maps
      jaq # jq in rust

      lact # GPU controller, needs a daemon

      # xorg.xwininfo # for stylish
      moor # test as pager
      presenterm # for presentations from terminal/markdown (in rust, supports images, pretty cool)

      sioyek # pdf reader
      tailspin # (broken) a log viewer based on less ("spin" or "tsspin" is the executable)
      # tig
      wally-cli # to flash ergodox keyboards
      wine

      # take the version from stable ?
      nautilus # demande webkit/todo replace by nemo ?
      # hexyl # hex editor
      # simple-scan
      # vifm
      # anyrun

      # bridge-utils# pour  brctl
    ];

  package-sets = {

    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    llms = false;
    enableIMPackages = true;
    japanese = true;
    enableGaming = true;
  };

  # package-sets.enableDesktopGUIPackages = true;

  home.sessionVariables = {
    # TODO create symlink ?
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";

    LLM_LOCAL_PORT = 11111;

    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

}
