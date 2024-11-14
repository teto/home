# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeInputs,
  flakeSelf,
  ...
}:
{

  imports =
    lib.optionals withSecrets [
      ../../../../desktop/home-manager/users/teto/calendars.nix
      ../../../../desktop/home-manager/users/teto/contacts.nix
      ../../../../desktop/home-manager/users/teto/mail.nix
      ../../../../desktop/home-manager/users/teto/sops.nix
      ../../../../desktop/home-manager/users/teto/programs/khal.nix

      flakeSelf.homeModules.nova
      ../../../../../hm/profiles/vdirsyncer.nix
      ../../../../../hm/profiles/experimental.nix
    ]
    ++ [
      ./sway.nix
      ./programs/waybar.nix
      ./services/mpd.nix
      ./services/blueman-applet.nix
      ./services/swayidle.nix

      # ../../../hm/profiles/emacs.nix
      ../../../../../hm/profiles/qutebrowser.nix

      # ../desktop/teto/default.nix  # Track for regressions

      ../../../../desktop/home-manager/users/teto/programs/ssh.nix
      ../../../../desktop/home-manager/users/teto/programs/bash.nix
      ../../../../desktop/home-manager/users/teto/programs/neovim.nix
      ../../../../desktop/home-manager/users/teto/programs/helix.nix
      ../../../../desktop/home-manager/users/teto/programs/yazi.nix
      ../../../../desktop/home-manager/users/teto/services/nextcloud-client.nix

      # ../../../hm/profiles/swayidle.nix
      ../../../../../hm/profiles/desktop.nix
      ../../../../../hm/profiles/japanese.nix
      ../../../../../hm/profiles/sway.nix
      ../../../../../hm/profiles/wezterm.nix
      flakeSelf.homeModules.yazi
      flakeSelf.homeModules.neovim
      flakeSelf.homeModules.developer
      flakeSelf.homeModules.package-sets

      # ../../../hm/profiles/dev.nix
      # ../../hm/profiles/syncthing.nix
      # ../../hm/profiles/alot.nix
      ../../../../../hm/profiles/vscode.nix # provided by nova-nix config
    ];

  # broken on unstable because python2
  services.opensnitch-ui.enable = false;

  package-sets = {
    enableDesktopGUIPackages = true;
    enableIMPackages = true;
    energy = true;
    wifi = true;
    llms = true;
  };

  programs.zsh = {
    enable = true;
    enableTetoConfig = true;
  };

  # just stow-config
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
    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    # nerdfonts
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

  programs.neovim.plugins = 
    [ pkgs.vimPlugins.vim-dadbod-ui ];
    # pkgs.callPackage ./programs/neovim.nix {};

  # systemd.user.settings.Manager.DefaultEnvironment = {
  #   # /home/teto/.nix-profile/bin:/nix/profile/bin:/home/teto/.local/state/nix/profile/bin:/etc/profiles/per-user/teto/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/teto/.local/share/../bin
  # };

}
