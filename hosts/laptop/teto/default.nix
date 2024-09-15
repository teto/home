# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeInputs,
  ...
}:
{

  imports =
    lib.optionals withSecrets [
      ../../../hm/profiles/nova.nix
      ../../desktop/teto/calendars.nix
      ../../desktop/teto/contacts.nix
      ../../desktop/teto/mail.nix
      ../../desktop/teto/sops.nix
      ../../../hm/profiles/vdirsyncer.nix

      ../../desktop/teto/programs/khal.nix
      ../../../hm/profiles/experimental.nix
    ]
    ++ [
      ./sway.nix
      ./programs/waybar.nix
      ./services/mpd.nix
      ./services/blueman-applet.nix
      ./services/swayidle.nix

      # ../../../hm/profiles/emacs.nix
      ../../../hm/profiles/qutebrowser.nix

      # ../desktop/teto/default.nix  # Track for regressions

      ../../desktop/teto/programs/neovim.nix
      ../../desktop/teto/services/swaync.nix
      ../../desktop/teto/programs/helix.nix
      ../../desktop/teto/programs/yazi.nix

      # ../../../hm/profiles/swayidle.nix
      ../../../hm/profiles/desktop.nix
      ../../../hm/profiles/extra.nix
      ../../../hm/profiles/japanese.nix
      ../../../hm/profiles/sway.nix
      ../../../hm/profiles/wezterm.nix
      ../../../hm/profiles/yazi.nix

      ../../../hm/profiles/dev.nix
      # ../../hm/profiles/syncthing.nix
      # ../../hm/profiles/alot.nix
      ../../../hm/profiles/vscode.nix # provided by nova-nix config
    ];

  package-sets = {
    enableDesktopGUIPackages = true;
    energy = true;
    wifi = true;
  };

  programs.zsh = {
    enable = true;
    enableTetoConfig = true;
  };

  # dans le cadre de mon experimentation !
  home.packages = with pkgs; [

    ubuntu_font_family
    inconsolata # monospace
    noto-fonts-cjk # asiatic
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
  systemd.user.settings.Manager.DefaultEnvironment = {
    PATH= "/home/teto/.nix-profile/bin";
# /home/teto/.nix-profile/bin:/nix/profile/bin:/home/teto/.local/state/nix/profile/bin:/etc/profiles/per-user/teto/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/home/teto/.local/share/../bin
  };
  programs.neovim.enable = true;
}
