{
  flakeSelf,
  pkgs,
  lib,
  config,
  osConfig,
  # withSecrets,
  secretsFolder,
  secrets,
  dotfilesPath,
  ...
}:

let
  inherit (lib) ignoreBroken;

  mkRemoteBuilderDesc =
    if lib ? mkRemoteBuilderDesc then
      lib.mkRemoteBuilderDesc
    else
      lib.warn "Using noop 'mkRemoteBuilderDesc' switch to 'scratch' branch" (_a: _b: "PLACEHOLDER");

  builder_neotokyo = mkRemoteBuilderDesc "3.0" (
    lib.nixosConfToBuilderAttr {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      # can
      # it's a base64 version of it
      publicHostKey = builtins.readFile ../../../../hosts/neotokyo/host_key.pub;
    } flakeSelf.nixosConfigurations.neotokyo
  );

  # public host key of the remote machine.  If omitted, SSH uses its regular known_hosts file.
  builder_jedha = mkRemoteBuilderDesc "3.0" (
    lib.nixosConfToBuilderAttr {
      sshKey = "${secretsFolder}/ssh/id_rsa";
      # I might need to set it ?
      publicHostKey = null;
      # favor jedha
      speedFactor = 2;
      maxJobs = 8;
    } flakeSelf.nixosConfigurations.jedha
  );

  # TODO fix
  builder_nixcommunity = mkRemoteBuilderDesc "3.0" (
    (lib.nix-builders.defaultBuilderAttrs { })
    // {
      sshUser = "teto";
      sshKey = "${secretsFolder}/ssh/nix-community-builder";
      protocol = "ssh";
      # I might need to set it ?
      publicHostKey = null; # builtins.readFile ../../../../hosts/neotokyo/host_key.pub;
      maxJobs = 3;
      speedFactor = 1.3;
      hostName = "build-box.nix-community.org";
      system = "x86_64-linux";
      # identitiesOnly yes
    }
  );
in
{
  imports = [
    flakeSelf.inputs.jj-gh.homeManagerModules.default
    flakeSelf.homeModules.memento
    flakeSelf.homeModules.kitty
    flakeSelf.homeModules.tig
    flakeSelf.homeModules.avante
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.services-mujmap
    flakeSelf.homeModules.package-sets
    flakeSelf.homeModules.nixpkgs-monitor
    flakeSelf.homeModules.firefox

    flakeSelf.homeProfiles.teto-aliases
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.sway-notification-center
    flakeSelf.homeProfiles.developer
    flakeSelf.homeProfiles.mpv
    # flakeSelf.homeProfiles.vscode
    # TODO cleanup and remove zsh
    flakeSelf.homeProfiles.teto-zsh
    # flakeSelf.homeProfiles.yt-dlp

    flakeSelf.inputs.nix-index-database.homeModules.nix-index
  ];

  # TODO restore this
  # to avoid cluttering $HOME
  # home.preferXdgDirectories = true;

  home.packages =
    with pkgs;

    [
      # bottles  # to install games
      mdcat # markdown viewer
      mitmproxy # help catch http traffic
      notmuch # needed for waybar-custom-notmuch.sh

      neovim-dbg # when neovim crashes, launch "nvim-debug" to debug

      ffsubsync # to sync subtitles
      # TODO provide debug package under different executable "nvim-debug"

      # qalc --exrates '100 EUR to CHF' to update rates from net
      libqalculate
      # panvimdoc # to generate vim doc from README, for instance in gp.nvim
      pciutils # for lspci

      # slidev-cli # text-based slides generate via npm nice prez
      # only for matt ?
      pass-perso
      # flakeSelf.inputs.pinix.packages.${pkgs.stdenv.hostPlatform.system}.default
      # poppler for pdf preview

      # kaggle # kaggle interface
      # python3Packages.kaggle

      lux-cli
      # flakeSelf.inputs.lux.packages.${pkgs.stdenv.hostPlatform.system}.lux-cli

      # rendercv # yaml-based CV

      stow
      systemctl-tui
      timr-tui # rust clock
      viu # a console image viewer

      # cups-pk-helper # to add printer through gnome control center
      pkgs.lm_sensors # to see CPU temperature (command 'sensors')
      pkgs.vlc # to see it in popcorn

      tarts # fun TUI screensaver, cmatrix-like

      # flakeSelf.inputs.git-repo-manager.packages.${pkgs.stdenv.hostPlatform.system}.git-repo-manager
    ];

  home.shell = {

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  home.shellAliases = {

    # add --remote-build if you meet signature issues
    # pass as shellAbbr
    # deploy-neotokyo = "deploy '.#neotokyo' -s --interactive-sudo=true -- --override-input nixpkgs /home/teto/nixpkgs";

    # lg = "lazygit";
    y = "yazi";
    yr = "yazi ./result";

    # js = "just -g switch";
    j = "just";
    jg = "just -g ";

    n = "nix develop";

    n1 = ''nix develop --option builders "$TETOS_BUILDER_NIXCOMMUNITY" -j0'';
    n2 = ''nix develop --option builders "$TETOS_1" -j0'';
    nr1 = ''nix run --option builders "$TETOS_BUILDER_NIXCOMMUNITY" -j0'';
    nr2 = ''nix run --option builders "$TETOS_1" -j0'';

    # trans aliases{{{
    fren = "trans -from fr -to en ";
    enfr = "trans -from en -to fr ";
    jpfr = "trans -from ja -to fr ";
    frjp = "trans -from fr -to ja ";
    jpen = "trans -from ja -to en ";
    enjp = "trans -from en -to ja ";
    # }}}
  };

  home.sessionVariables = {
    VIBE_HOME = "${config.xdg.configHome}/vibe";
    # might be a hack
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true"; # it must be "true" and nothing else !
    PASSWORD_STORE_EXTENSIONS_DIR = "${dotfilesPath}/contrib/pass-extensions";

    # TODO set it globally ?
    CDPATH = "$HOME/plugins";

  }
  // lib.optionalAttrs osConfig.tetos.withSecrets {
    # customsearch cancelled ffs
    # GOOGLE_SEARCH_ENGINE_ID="64ff2b96809e947cc";
    # GOOGLE_SEARCH_API_KEY=secrets.google.customsearch_api_key;
    TETOS_BUILDER_NEOTOKYO = builder_neotokyo;
    TETOS_BUILDER_JEDHA = builder_jedha;
    TETOS_BUILDER_NIXCOMMUNITY = builder_nixcommunity;
    inherit (secrets) TAVILY_API_KEY;

  };

  home.sessionSearchVariables = {

    PATH = [
      "$HOME/.cargo/bin"
      # "$HOME/.cache/npm-packages/bin"
      "${dotfilesPath}/rofi-scripts"
    ];
  };

  # "* ${builtins.readFile ../../../perso/keys/id_rsa.pub}";
  home.file.".ssh/allowed_signers".text = ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC/+rkPJvHRlXBuOI7NSQTAXBBsFjjcKchNm+hIs1kpwrpwNvEQUg1U2xuLvS5AEBdFdqUn6V67uGB6sfSDwS7dUakV5E9Cvmadw0cenZ7DSMaUAqMqAhVtY2Rzx3iNfD2sDBItdU9lyXrg6rwl0nPy+EfJPItV/wvJnI7a8dxdNf0PbbdZTQLDPpGlRec4+tvPQNvwRl5x5Y39jWqtTUrRDF11d/b99lcIaihnPvlRi53FfvypwdMuFf81Ufc/4klAP80GTYIDlWh1juMCF0tIp0rb5iE4+ABbTVAczE2iO8lYYGtqOPe/YGJ+7RwrGnDVdwhsq3A9iT76T2mvLtn teto@tatooine
  '';

  package-sets = {

    domotic = true;
    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    enableIMPackages = true;
    jujutsu = true;
    yubikey = true;
    waylandPackages = true;
  };

  home.language = {
    # monetary =
    # measurement =
    # numeric =
    # paper =
    base = "fr_FR.utf8";
    time = "fr_FR.utf8";
  };
}
