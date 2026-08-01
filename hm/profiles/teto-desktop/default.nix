{
  flakeSelf,
  pkgs,
  lib,
  config,
  withSecrets,
  secretsFolder,
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
      publicHostKey = null;
      maxJobs = 0;
      speedFactor = 1;
      hostName = "hostname build-box.nix-community.org";
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
  # # generate an addressbook that can be used later
  # home.file."bin-nix/generate-addressbook".text = ''
  #   #!/bin/sh
  #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  # '';

  # to avoid cluttering $HOME
  # home.preferXdgDirectories = true;

  home.packages =
    with pkgs;

    [
      # bottles  # to install games
      mdcat # markdown viewer
      (ignoreBroken mitmproxy) # help catch http traffic
      notmuch # needed for waybar-custom-notmuch.sh

      neovim-dbg # when neovim crashes, launch "nvim-debug" to debug

      ffsubsync # to sync subtitles
      # TODO provide debug package under different executable "nvim-debug"

      panvimdoc # to generate vim doc from README, for instance in gp.nvim
      pciutils # for lspci

      # slidev-cli # text-based slides generate via npm nice prez
      # only for matt ?
      pass-perso
      flakeSelf.inputs.pinix.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    deploy-neotokyo = "deploy '.#neotokyo' -s --interactive-sudo=true -- --override-input nixpkgs /home/teto/nixpkgs";


    # lg = "lazygit";
    y = "yazi";
    yr = "yazi ./result";

    js = "just -g switch";
    j = "just";
    jg = "just -g ";

    n = "nix develop";

    n1 = ''nix develop --option builders "$TETOS_0" -j0'';
    n2 = ''nix develop --option builders "$TETOS_1" -j0'';
    nr1 = ''nix run --option builders "$TETOS_0" -j0'';
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

    TETOS_0 = builder_neotokyo;
    TETOS_1 = builder_jedha;
    TETOS_2 = builder_nixcommunity;
  };

  home.sessionSearchVariables = {

    PATH = [
      "$HOME/.cargo/bin"
      # "$HOME/.cache/npm-packages/bin"
      "${dotfilesPath}/rofi-scripts"
    ];
  };

  # rofi module doesn't have extraConfig
  # https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown
  # @theme "gruvbox-light"
  # home.file."${config.programs.rofi.configPath}".text = ''
  #   ?import "${config.xdg.configHome}/rofi/manual.rasi"
  #
  #   @import "${config.xdg.cacheHome}/wallust/colors.rasi"
  #
  # '';

  package-sets = {

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
