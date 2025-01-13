# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  # dotfilesPath,
  ...
}:
{

  imports =
    lib.optionals withSecrets [
      ../../../../desktop/home-manager/users/teto/calendars.nix
      ../../../../desktop/home-manager/users/teto/contacts.nix
      ../../../../desktop/home-manager/users/teto/mail.nix
      ../../../../desktop/home-manager/users/teto/sops.nix

      flakeSelf.homeModules.nova
      ../../../../../hm/profiles/vdirsyncer.nix
      # ../../../../../hm/modules/tig.nix
      flakeSelf.homeModules.tig
      # flakeSelf.inputs.git-repo-manager.packages.${pkgs.system}.git-repo-manager
    ]
    ++ [
      flakeSelf.homeModules.experimental
      flakeSelf.homeModules.sway-notification-center
      ./sway.nix
      ./programs/waybar.nix
      ./programs/neovim.nix
      ./services/mpd.nix
      ./services/blueman-applet.nix
      ./services/swayidle.nix

      # ../../../hm/profiles/emacs.nix
      ../../../../../hm/profiles/qutebrowser.nix

      # ../desktop/teto/default.nix  # Track for regressions

      # ../../../../desktop/home-manager/users/teto/programs/ssh.nix
      # ../../../../desktop/home-manager/users/teto/programs/bash.nix

      # neovim should come from the nixos profile
      # ../../../../desktop/home-manager/users/teto/programs/neovim.nix
      ../../../../desktop/home-manager/users/teto/services/nextcloud-client.nix

      # ../../../hm/profiles/swayidle.nix
      # ../../../../../hm/profiles/sway.nix
      ../../../../../hm/profiles/wezterm.nix

      flakeSelf.homeModules.teto-desktop
      flakeSelf.homeModules.yazi
      flakeSelf.homeModules.mpv
      flakeSelf.homeModules.neovim
      flakeSelf.homeModules.developer
      flakeSelf.homeModules.package-sets

      flakeSelf.homeModules.vscode

    ];

  programs.tig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # broken on unstable because python2
  services.opensnitch-ui.enable = false;

  package-sets = {
    enableDesktopGUIPackages = true;
    enableIMPackages = true;
    enableOfficePackages = true;
    scientificSoftware = true;
    energy = true;
    wifi = true;
    llms = true;
    japanese = true;
  };

  programs.fre = {
    enable = true;
    enableAsFzfFile = true;
  };

  programs.zsh = {
    enable = true;
    enableTetoConfig = true;
  };

  #  stow-config / stow-home ?
  home.file.".inputrc" = {
    # dotfilesPath
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/home/home/dot-inputrc";
  };

  # xdg.configFile = {
  #   "zsh" = {
  #     source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
  #     recursive = true;
  #   };
  #   # ...
  # };

  # dans le cadre de mon experimentation !
  home.packages = with pkgs; [

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
    # noto-fonts
  ];

  # pkgs.callPackage ./programs/neovim.nix {};

  # TODO move upper ?
  systemd.user.settings.Manager.DefaultEnvironment = {
    NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/default/config";
    # for vdirsyncer
    # NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/default/config";
  };

  #   # /home/teto/.nix-profile/bin:/nix/profile/bin:/home/teto/.local/state/nix/profile/bin:/etc/profiles/per-user/teto/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/teto/.local/share/../bin
  # };

}
