{
  config,
  flakeInputs,
  pkgs,
  # lib,
  # system,
  withSecrets,
  dotfilesPath,
  secretsFolder,
  ...
}:
let

  autoloadedModule =
    { pkgs, ... }@args:
    flakeInputs.haumea.lib.load {
      src = ./desktop;
      #   flakeInputs.nix-filter {
      #   root = ./desktop;
      # };
      inputs = args // {
        inputs = flakeInputs;
      };
      transformer = [
        flakeInputs.haumea.lib.transformers.liftDefault
        (flakeInputs.haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

  fontsPkgs = with pkgs; [
    # fonts
    ubuntu_font_family
    inconsolata # monospace

    noto-fonts-cjk-sans # asiatic
    nerd-fonts.fira-code # otherwise no characters
    nerd-fonts.droid-sans-mono # otherwise no characters

    # corefonts # microsoft fonts  UNFREE
    font-awesome_5
    source-code-pro
    dejavu_fonts
    # Adobe Source Han Sans
    source-han-sans # sourceHanSansPackages.japanese
    fira-code-symbols # for ligatures
    iosevka

  ];

in
{

  imports = [
    autoloadedModule
    ./xdg-portal.nix
    ./common.nix
    ./dev.nix
    ./sway.nix
    ./zsh.nix

    # ./fcitx.nix
    ./neovim.nix
  ];

  # allows to find fonts enabled through home.packages
  fonts.fontconfig.enable = true;

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

  };

  # rename to fn, accept a parameter for optional
  home.packages =
    fontsPkgs
    ++ (with pkgs; [
      # pkgs.up # live preview of pipes
      # pkgs.peek # GIF recorder  BROKEN
      pkgs.alsa-utils # for alsamixer
      pkgs.lm_sensors # for `sensors` executable
      # pinentry-bemenu
      pinentry-rofi
      # gnome3.gnome-font-viewer  # Not very good

      timg
      gh-dash
    ]);

  # TODO remove ? dangerous
  home.sessionPath = [
    "$XDG_DATA_HOME/../bin"
    "${dotfilesPath}/bin"
  ];

  services.network-manager-applet.enable = true;

  # needed for gpg-agent gnome pinentry
  # services.dbus.packages = [ pkgs.gcr ];

  programs.rbw = {
    enable = withSecrets;
    settings = {
      email = config.accounts.email.accounts.fastmail.address;
      lock_timeout = 300;
      # pinentry = pkgs.pinentry-gnome3;
      pinentry = pkgs.pinentry-rofi;
      # see https://github.com/nix-community/home-manager/issues/2476
      device_id = "111252f7-88b7-47f2-abb9-03dc4b2469ed";
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = true;

}
