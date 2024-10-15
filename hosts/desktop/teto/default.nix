# home-manager specific config from
{
  config,
  lib,
  flakeInputs,
  pkgs,
  withSecrets,
  dotfilesPath,
  ...
}:
# let
# module = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
#   src = ./haumea-test;
#   inputs = args // {
#     inputs = flakeInputs;
#   };
#   transformer = flakeInputs.haumea.lib.transformers.liftDefault;
# };
# in
{

  # services.nextcloud-client.enable = true;

  imports =
    [
      ../../../hm/profiles/bash.nix

      ../../../hm/profiles/nova/programs/bash.nix
      ../../../hm/teto/common.nix
      # ../../../hm/profiles/common.nix
      ../../../hm/profiles/desktop.nix
      ../../../hm/profiles/wezterm.nix
      # flakeInputs.ironbar.homeManagerModules.default

      ./calendars.nix
      ./sway.nix

      ./programs/bash.nix
      ./programs/git.nix
      ./programs/helix.nix
      ./programs/neovim.nix
      ./programs/ssh.nix
      ./programs/yazi.nix
      ./programs/khal.nix
      ./programs/waybar.nix
      ./programs/zsh.nix

      ./services/swaync.nix
      ./services/mpd.nix
      ./services/mpris.nix
      ./services/nextcloud-client.nix
      # ../../../hm/profiles/experimental.nix

      # Not tracked, so doesn't need to go in per-machine subdir
      ../../../hm/profiles/gnome.nix
      ../../../hm/profiles/waybar.nix
      # ../../../hm/profiles/fcitx.nix
      ../../../hm/profiles/vscode.nix
      # custom modules
      ../../../hm/profiles/emacs.nix
      ../../../hm/profiles/zsh.nix
      # ../../hm/profiles/weechat.nix
    ]
    ++ lib.optionals withSecrets [
      ./sops.nix
      ./mail.nix
      ./ia.nix
      ../../../hm/profiles/ia.nix
      ../../../hm/profiles/neomutt.nix
      # ../../../hm/profiles/nushell.nix
      ../../../hm/profiles/alot.nix
      ../../../hm/profiles/android.nix
      ../../../hm/profiles/gaming.nix

      ../../../hm/profiles/nova.nix
      ../../../hm/profiles/extra.nix
      ../../../hm/profiles/extra.nix
      ../../../hm/profiles/vdirsyncer.nix
      ../../../hm/profiles/japanese.nix
    ];

  # TODO use mkSymlinkOufOf  ? ?
  # xdg.configFile."zsh/zshrc.generated".source = ../../../config/zsh/zshrc;

  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };

  home.file.".gdbinit".text = ''
    # ../config/gdbinit_simple;
    # gdb doesn't accept environment variable except via python
    source ${config.xdg.configHome}/gdb/gdbinit_simple
    set history filename ${config.xdg.cacheHome}/gdb_history
  '';

  home.language = {
    # monetary = 
    # measurement = 
    # numeric = 
    # paper =
    time = "fr_FR.utf8";
  };

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = true;
    # 229 fr_FR.UTF-8/UTF-8 \
    # 230 fr_FR/ISO-8859-1 \
    # 231 fr_FR@euro/ISO-8859-15 \
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # works only because TIGRC_USER is set
  # if file exists vim.tigrc
  home.file."${config.xdg.configHome}/tig/config".text = ''
    source ${pkgs.tig}/etc/vim.tigrc
    # not provided
    # source ${pkgs.tig}/tig/contrib/large-repo.tigrc
    source ${config.xdg.configHome}/tig/custom.tigrc
  '';

  # seulemt pour X
  # programs.feh.enable = true;
  # for programs not merged yet
  home.packages = with pkgs; [
    # llm-ls # needed by the neovim plugin

    # mdp # markdown CLI presenter
    # gthumb # image manager, great to tag pictures
    gnome-control-center
    gnome-maps
    # xorg.xwininfo # for stylish
    pciutils # for lspci
    moar # test as pager
    tailspin # a log viewer based on less ("spin" or "tsspin" is the executable)
    tig

    panvimdoc # to generate vim doc from README, for instance in gp.nvim

    presenterm # for presentations from terminal/markdown (in rust, supports images, pretty cool)

    lutris # for gaming

    sioyek # pdf reader
    jaq # jq in rust
    viu # a console image viewer
    wally-cli # to flash ergodox keyboards
    wine

    # take the version from stable ?
    qutebrowser # broken keyboard driven fantastic browser
    nautilus # demande webkit/todo replace by nemo ?
    # hexyl # hex editor
    # simple-scan
    # vifm
    # anyrun

    # w3m # for preview in ranger w3mimgdisplay

    # bridge-utils# pour  brctl
    # ironbar 
    # haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720

    unar # used to view archives by yazi
    # poppler for pdf preview
    memento # capable to display 2 subtitles at same time

    rofi-rbw-wayland
  ];

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

    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets

  };

}
