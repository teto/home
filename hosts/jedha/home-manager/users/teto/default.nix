# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  autoloadedProfiles =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = lib.fileset.toSource {
        root = ./.;
        fileset = ./programs/noctalia.nix;
      };

      inputs = args // {
        osConfig = config;
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };
in
{

  # disabled because fucks up with fish
  # bash: set: -g : option non valable
  # ++++ set -gx __DIRENV_INSTANT_ENV_FILE /home/teto/.cache/direnv-instant/6b72ed9c0367a2e2/env
  # bash: set: -g : option non valable
  programs.direnv-instant.enable = false;

  imports = [
    flakeSelf.homeProfiles.teto-desktop

    # flakeSelf.homeModules.bash
    flakeSelf.inputs.direnv-instant.homeModules.direnv-instant

    # flakeSelf.homeProfiles.qutebrowser # does nothing

    flakeSelf.homeProfiles.experimental
    flakeSelf.homeProfiles.wezterm
    # flakeSelf.homeModules.gnome-shell

    flakeSelf.homeModules.neovim
    flakeSelf.homeModules.nextcloud-client
    flakeSelf.homeModules.llama-cpp

    ./calendars.nix
    ./sway.nix
    ./systemd.nix

    ./programs/neovim.nix
    # ./programs/noctalia.nix
    # ./programs/waybar.nix # TODO resotre ?
    ./programs/zsh.nix

    ./services/llama-cpp.nix
    # ./services/local-ai.nix
    # ./services/ollama.nix
    ./services/kanshi.nix
    ./services/ssh-agent.nix
    ./services/mpd.nix
    ./services/mpris.nix
  ]
  ++ lib.optionals withSecrets [
    ./sops.nix
    ./ia.nix
  ];

  # services.opensnitch-ui.enable

  # xdg.configFile."zsh/zshrc.generated".source = ../../../config/zsh/zshrc;

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
      llmDeps = [
        # python3Packages.llama-index-cli
        # python3Packages.llama-index
        # pkgs.mokuro
        # pkgs.python3Packages.manga-ocr
      ];
    in
    llmDeps
    ++ [
      # disable for now because of
      # >   `/nix/store/klzrf7krj1whzms0cbk8hw7nyrn013c3-rag-service-env/bin/activate' and
      # >   `/nix/store/pzvl9qcgq404rmd3jasn5hvwh3frp75r-deploy-rs-0.1.0/bin/activate'
      # flakeSelf.inputs.avante-nvim.packages.${pkgs.stdenv.hostPlatform.system}.ragService

      # llm-ls # needed by the neovim plugin
      cointop # bitcoin tracker
      # mdp # markdown CLI presenter
      # gthumb # image manager, great to tag pictures

      jocalsend # for tests

      ethtool # to check wakeonlan capabilities
      # footswitch # to control foot pedals (use module instead)
      # need gnome-accounts to make it work
      gnome-calendar
      gnome-control-center
      # gnome-maps

      jaq # jq in rust

      (lib.ignoreBroken lact) # GPU controller, needs a daemon

      moor # test as pager
      presenterm # for presentations from terminal/markdown (in rust, supports images, pretty cool)

      # sioyek # pdf reader
      tailspin # (broken) a log viewer based on less ("spin" or "tsspin" is the executable)
      # tig
      wally-cli # to flash ergodox keyboards
      wine

      nix-sweep # smarter nix-gc

      # take the version from stable ?
      nautilus # demande webkit/todo replace by nemo ?
      # hexyl # hex editor
      # simple-scan
      # vifm
      # anyrun

      # bridge-utils# pour  brctl

      # vscode-css-languageserver # to showcase 'cssls' lsp server
      videocr # to extract hardcorded subs

    ];

  package-sets = {

    wifi = true;
    livecoding = false;
    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    finance = true;
    llms = true;
    enableIMPackages = true;
    japanese = true;
    enableGaming = true;

    music-processing = false;
  };

  # package-sets.enableDesktopGUIPackages = true;
  home.stateVersion = "26.05";

  home.sessionVariables = {
    # TODO create symlink ?
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    LLAMA_MODELS_DIR = "${config.home.homeDirectory}/llama-models";

    LLM_LOCAL_PORT = 11111;

    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

}
