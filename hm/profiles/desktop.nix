{
  config,
  flakeSelf,
  pkgs,
  lib,
  # system,
  withSecrets,
  secrets,
  dotfilesPath,
  secretsFolder,
  ...
}:
let

  haumea = flakeSelf.inputs.haumea;
  autoloadedModule =
    { pkgs, ... }@args:
    haumea.lib.load {
      # flakeSelf.inputs.nix-filter {
      src = ./teto-desktop;
      inputs = args // {
        inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{

  imports = [
    autoloadedModule
    ./common.nix
    flakeSelf.homeProfiles.teto-zsh
    flakeSelf.homeProfiles.sway
    flakeSelf.homeProfiles.neovim

  ];

  home.file.".password-store".source =
    config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/password-store-perso";
  # TODO link .config
  # home.file.".password-store".source = config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/password-store-teto";
  # home.file.".gnupg".source = config.lib.file.mkOutOfStoreSymlink "${secretsFolder}/gnupg";

  # allows to find fonts enabled through home.packages
  fonts.fontconfig.enable = true;

  programs.delta.enable = true;

  xdg = {
    enable = true;
    mime.enable = true;
  };

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = true;
    # 229 fr_FR.UTF-8/UTF-8 \
    # 230 fr_FR/ISO-8859-1 \
    # 231 fr_FR@euro/ISO-8859-15 \
    # pass on japanese one as well ?
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      # "en_US.UTF-8/UTF-8"
    ];
  };

  # programs.zoxide = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   enableBashIntegration = true;
  #   options = [ "--cmd k" ];
  # };

  package-sets = {
    developer = true;
    desktop = true;
    energy = true;
    scientificSoftware = true;
    fonts = true;
  };

  # rename to fn, accept a parameter for optional
  home.packages = (
    with pkgs;
    [
      # pkgs.up # live preview of pipes
      # pkgs.peek # GIF recorder  BROKEN
      pkgs.alsa-utils # for alsamixer
      pkgs.lm_sensors # for `sensors` executable
      # pinentry-bemenu
      pinentry-rofi
      pciutils # for lspci
      # gnome3.gnome-font-viewer  # Not very good

      timg
      gh-dash
      wpaperd
    ]
  );

  # TODO remove ? dangerous
  home.sessionPath = lib.mkBefore [
    "$XDG_DATA_HOME/../bin"
    "${dotfilesPath}/bin"
  ];

  services.network-manager-applet.enable = true;

  # needed for gpg-agent gnome pinentry
  # services.dbus.packages = [ pkgs.gcr ];
  programs.nvimpager.enable = false; # too slow

  programs.rbw = {
    enable = withSecrets;
    settings = {
      email = config.accounts.email.accounts.fastmail.address;
      lock_timeout = 300;
      # pinentry = pkgs.pinentry-gnome3;
      pinentry = pkgs.pinentry-rofi;
      # see https://github.com/nix-community/home-manager/issues/2476
      device_id = secrets.bitwarden.device-id;
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

}
