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

  imports = [
    flakeSelf.homeProfiles.teto-desktop

    # flakeSelf.homeModules.experimental
    flakeSelf.homeProfiles.neovim

    ./wayland.nix
    ./programs/waybar.nix
    ./programs/neovim.nix
    ./programs/zsh.nix
    ./services/mpd.nix
    ./services/blueman-applet.nix
    ./services/wpaperd.nix
    # ./services/swayidle.nix
    # ../desktop/teto/default.nix  # Track for regressions

    # neovim should come from the nixos profile
    flakeSelf.homeModules.nextcloud-client
    flakeSelf.homeModules.llama-cpp

    # flakeSelf.homeProfiles.llama-cpp
    flakeSelf.homeProfiles.wezterm
  ];

  # testing
  services.llama-cpp = {
    enable = false;
  };

  # programs.memento.enable = true;
  home.stateVersion = "26.05";

  home.sessionPath = [
    # "$HOME/.local/bin"
  ];

  # broken on unstable because python2
  # services.opensnitch-ui.enable = false;

  programs.nh.enable = true;

  # TODO enable sandboxing
  programs.claude-code.enable = false;

  home.packages = [
    # pkgs.claude-code
    # pkgs.llama-cpp
    pkgs.batctl # to control battery thresholds
  ];

  package-sets = {
    livecoding = false;
    bluetooth = true;
    enableDesktopGUIPackages = true;
    enableIMPackages = true;
    scientificSoftware = true;
    energy = true;
    wifi = true;
    llms = false;
    japanese = true;
  };

  # tow-config / stow-home ?
  # home.file.".inputrc" = {
  #   # dotfilesPath
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/home/home/dot-inputrc";
  # };

  # xdg.configFile = {
  #   "zsh" = {
  #     source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
  #     recursive = true;
  #   };
  #   # ...
  # };

}
