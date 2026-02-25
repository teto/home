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

  home.sessionPath = [
    # "$HOME/.local/bin"
  ];

  # broken on unstable because python2
  # services.opensnitch-ui.enable = false;

  programs.nh.enable = false;

  # TODO enable sandboxing
  programs.claude-code.enable = true;

  home.packages = [
    # pkgs.claude-code
    pkgs.llama-cpp
  ];

  package-sets = {
    # livecoding
    audio = false;
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
