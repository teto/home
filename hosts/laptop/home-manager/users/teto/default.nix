# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  ...
}:
{

  imports =
    lib.optionals withSecrets [
      # ../../../../desktop/home-manager/users/teto/calendars.nix
      # ../../../../desktop/home-manager/users/teto/contacts.nix

      # TODO
      # ../../../../desktop/home-manager/users/teto/sops.nix

      # flakeSelf.inputs.git-repo-manager.packages.${pkgs.system}.git-repo-manager
    ]
    ++ [
      # flakeSelf.homeModules.experimental
      ./sway.nix
      ./programs/waybar.nix
      ./programs/neovim.nix
      ./programs/zsh.nix
      ./services/mpd.nix
      ./services/blueman-applet.nix
      ./services/wpaperd.nix
      # ./services/swayidle.nix

      # ../desktop/teto/default.nix  # Track for regressions

      # neovim should come from the nixos profile
      ../../../../desktop/home-manager/users/teto/services/nextcloud-client.nix

      # ../../../../../hm/profiles/wezterm.nix
      flakeSelf.homeProfiles.wezterm
    ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # broken on unstable because python2
  # services.opensnitch-ui.enable = false;

  programs.nh.enable = true;

  package-sets = {
    enableDesktopGUIPackages = true;
    enableIMPackages = true;
    scientificSoftware = true;
    energy = true;
    wifi = true;
    llms = true;
    japanese = true;
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

  # TODO move upper ?

}
