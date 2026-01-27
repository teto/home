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
in
{
  imports = [

    flakeSelf.homeProfiles.teto-aliases
    flakeSelf.homeProfiles.common
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.sway-notification-center
    flakeSelf.homeProfiles.developer
    flakeSelf.homeProfiles.mpv
    flakeSelf.homeProfiles.vscode
    flakeSelf.homeProfiles.teto-zsh
    # flakeSelf.homeProfiles.yt-dlp

    flakeSelf.homeModules.avante
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.services-mujmap
    flakeSelf.homeModules.pimsync
    flakeSelf.homeModules.package-sets
  ];

  # TODO restore this
  # # generate an addressbook that can be used later
  # home.file."bin-nix/generate-addressbook".text = ''
  #   #!/bin/sh
  #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  # '';

  home.packages = with pkgs; [
    (ignoreBroken pkgs.aider-chat) # breaks
    mdcat # markdown viewer
    notmuch # needed for waybar-custom-notmuch.sh
    panvimdoc # to generate vim doc from README, for instance in gp.nvim
    pciutils # for lspci

    # slidev-cli # text-based slides generate via npm nice prez
    # only for matt ?
    pass-perso
    # poppler for pdf preview

    rendercv  # yaml-based CV
    stow
    timr-tui # rust clock
    systemctl-tui
    viu # a console image viewer

    tarts # fun TUI screensaver, cmatrix-like

    # flakeSelf.inputs.git-repo-manager.packages.${pkgs.stdenv.hostPlatform.system}.git-repo-manager
  ];

  home.shell = {

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  home.shellAliases = {
    lg = "lazygit";
    st = "systemctl-tui";
    yr = "yazi ./result";

    js = "just switch";
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
  };

  home.sessionSearchVariables = {

    PATH = [
      "$HOME/.cargo/bin"
      "$HOME/.cache/npm-packages/bin"
      "${dotfilesPath}/rofi-scripts"
    ];
  };

  # rofi module doesn't have extraConfig
  # https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown
  # @theme "gruvbox-light"
  home.file."${config.programs.rofi.configPath}".text = ''
    ?import "${config.xdg.configHome}/rofi/manual.rasi"

    @import "${config.xdg.cacheHome}/wallust/colors.rasi"

  '';

  package-sets = {

    enableOfficePackages = true;
    kubernetes = true;
    developer = true;
    enableIMPackages = true;
    jujutsu = true;
    yubikey = true;
    waylandPackages = true;
  };

  # neovim workarounds:
  # - for treesitter (provide compiler such that nvim-treesitter can install grammars
  # - for rocks.nvim: give him a tree to luarocks
  # todo should depend on
  # xdg.

  home.language = {
    # monetary =
    # measurement =
    # numeric =
    # paper =
    base = "fr_FR.utf8";
    time = "fr_FR.utf8";
  };

  # wayland.systemd.target = graphical-session.target
}
