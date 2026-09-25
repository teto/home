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
    flakeSelf.inputs.chroncal.homeModules.default
    flakeSelf.inputs.nix-index-database.homeModules.nix-index

    flakeSelf.homeModules.avante
    flakeSelf.homeModules.firefox
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.kitty
    flakeSelf.homeModules.memento
    flakeSelf.homeModules.nixpkgs-monitor
    flakeSelf.homeModules.package-sets
    flakeSelf.homeModules.services-mujmap
    flakeSelf.homeModules.tig
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.yubikey
    flakeSelf.homeModules.zsh

    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.developer
    flakeSelf.homeProfiles.mpv
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.sway-notification-center
    flakeSelf.homeProfiles.teto-aliases

    # flakeSelf.homeProfiles.vscode
    # TODO cleanup and remove zsh
    # flakeSelf.homeProfiles.teto-zsh
    # flakeSelf.homeProfiles.yt-dlp

  ];

  # TODO restore this
  # to avoid cluttering $HOME
  # home.preferXdgDirectories = true;

  # needed for gpg-agent gnome pinentry
  # services.dbus.packages = [ pkgs.gcr ];

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

  home.pointerCursor = {
    sway.enable = true;
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    sway.size = 32;
  };

  home.packages =
    with pkgs;

    [
      pkgs.pinentry-curses

      # for the noctalia OCR plugin
      pkgs.grim
      pkgs.slurp
      pkgs.tesseract

      # pkgs.up # live preview of pipes
      pkgs.peek # GIF recorder  BROKEN
      # pkgs.sequoia-sq # gpg rust replacement ? exe is called "sq"
      pkgs.sshfs # to download
      pkgs.alsa-utils # for alsamixer
      pkgs.lm_sensors # for `sensors` executable
      flakeSelf.inputs.deploy-rs.packages.${stdenv.hostPlatform.system}.deploy-rs
      pciutils # for lspci
      timg
      ncurses.dev # for infocmp

      # josm # openstreetmap editor (java)

      gh-dash
      pi-coding-agent # to test as ACP provider for avante
      # bottles  # to install games
      mdcat # markdown viewer
      mcat # universal viewer
      mitmproxy # help catch http traffic
      notmuch # needed

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

      stow
      systemctl-tui
      timr-tui # rust clock

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
    # use nix-sweep instead ?
    nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/proc|/run/\w+-system|\{memory)" | less'';

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
    # VIBE_HOME = "${config.xdg.configHome}/vibe";
    # might be a hack
    PASSWORD_STORE_ENABLE_EXTENSIONS = "true"; # it must be "true" and nothing else !
    PASSWORD_STORE_EXTENSIONS_DIR = "${dotfilesPath}/contrib/pass-extensions";

    # TODO set it globally ?
    CDPATH = "$HOME/plugins";
    PAGER = "bat";

    MANPAGER = "moor";
    # MANPAGER = "less -R -i --use-color -Dd+M -Du+C";
    # MANROFFOPT = "-c";
  }
  // lib.optionalAttrs osConfig.tetos.withSecrets {
    TETOS_BUILDER_NEOTOKYO = builder_neotokyo;
    TETOS_BUILDER_JEDHA = builder_jedha;
    TETOS_BUILDER_NIXCOMMUNITY = builder_nixcommunity;
    inherit (secrets) TAVILY_API_KEY;
  };

  # tetos.enableYubikey = true;

  home.sessionSearchVariables = {

    PATH = [
      "$HOME/.cargo/bin"
      # "$HOME/.cache/npm-packages/bin"
      "${dotfilesPath}/rofi-scripts"
    ];
  };

  package-sets = {
    desktop = true;
    energy = true;
    scientificSoftware = true;
    fonts = true;

    domotic = true;
    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    enableIMPackages = true;
    jujutsu = true;
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
