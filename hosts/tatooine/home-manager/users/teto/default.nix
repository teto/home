# home-manager specific config from
{
  config,
  lib,
  pkgs,
  withSecrets,
  flakeSelf,
  ...
}:
let 
  haumea = flakeSelf.inputs.haumea;

  autoloadedTeto =
    { pkgs, ... }@args:
    haumea.lib.load {
      src = flakeSelf.inputs.nix-filter {
        name = "laptopAutoloaded";
        root = ./.;
        # include = [
        #   # "home-manager/users/teto/programs/neovim.nix"
        #   # "home-manager/users/teto/programs/noctalia-shell.nix"
        #   # "home-manager/users/teto/programs/noctalia-shell-settings.json"
        #   # "home-manager/users/teto/wayland.nix"
        #   # "home-manager/users/teto/services/blueman-applet.nix"
        #   # "home-manager/users/teto/services/mpd.nix"
        # ];

        exclude = [
          "default.nix"
        ];
      };

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
    autoloadedTeto
    flakeSelf.homeProfiles.teto-desktop
    #
    # # flakeSelf.homeModules.experimental
    flakeSelf.homeProfiles.neovim
    flakeSelf.homeProfiles.sway

    # ./wayland.nix
    # ./programs/neovim.nix
    # ./programs/noctalia-shell.nix
    # ./programs/zsh.nix
    # ./services/mpd.nix
    # ./services/blueman-applet.nix
    # ./services/wpaperd.nix
    # ./services/swayidle.nix
    # ../desktop/teto/default.nix  # Track for regressions

    # neovim should come from the nixos profile
    flakeSelf.homeModules.nextcloud-client
    flakeSelf.homeModules.llama-cpp

    flakeSelf.homeProfiles.wezterm
  ];

  # programs.memento.enable = true;
  home.stateVersion = "26.05";

  home.sessionPath = [
    # "$HOME/.local/bin"
  ];

  # broken on unstable because python2
  # services.opensnitch-ui.enable = false;

  # TODO enable sandboxing
  # programs.claude-code.enable = false;

  home.packages = [
    # pkgs.claude-code
    flakeSelf.inputs.nixos-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.llama-cpp
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
