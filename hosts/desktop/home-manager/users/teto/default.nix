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

  imports =
    [
      # flakeSelf.homeModules.bash

      flakeSelf.homeProfiles.qutebrowser
      flakeSelf.inputs.nix-index-database.hmModules.nix-index

      flakeSelf.homeModules.teto-nogui
      flakeSelf.homeModules.ollama
      flakeSelf.homeModules.experimental
      flakeSelf.homeProfiles.wezterm
      # flakeSelf.homeModules.gnome-shell

      ./calendars.nix
      ./sway.nix

      ./programs/neovim.nix
      ./programs/waybar.nix
      ./programs/zsh.nix

      ./services/kanshi.nix
      ./services/ssh-agent.nix
      ./services/swaync.nix
      ./services/mpd.nix
      ./services/mpris.nix
      ./services/nextcloud-client.nix
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
    let
      fonts = [
        ubuntu_font_family
        inconsolata # monospace
        noto-fonts-cjk-sans # asiatic
        nerd-fonts.fira-code # otherwise no characters
        nerd-fonts.droid-sans-mono # otherwise no characters
        # corefonts # microsoft fonts  UNFREE
        font-awesome_5 # needed for waybar
        source-code-pro
        dejavu_fonts
        # Adobe Source Han Sans
        source-han-sans # sourceHanSansPackages.japanese
        fira-code-symbols # for ligatures
        iosevka
        # noto-fonts

      ];
    in
    [
      # llm-ls # needed by the neovim plugin

      cointop # bitcoin tracker
      # mdp # markdown CLI presenter
      # gthumb # image manager, great to tag pictures
      gnome-control-center
      gnome-maps
      jaq # jq in rust

      lact # GPU controller, needs a daemon
      lutris # for gaming
      # xorg.xwininfo # for stylish
      moar # test as pager
      pciutils # for lspci
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
      # w3m # for preview in ranger w3mimgdisplay

      # bridge-utils# pour  brctl
      # ironbar
      # haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720

    ]
    ++ fonts;

  package-sets = {

    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    llms = true;
    enableIMPackages = true;
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

  systemd.user.services.xwayland-satellite = {
    Service = {
      # TODO need DBUS_SESSION_BUS_ADDRESS
      # --app-name="%N" toto
      Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
      Exec = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
    };
  };
}
