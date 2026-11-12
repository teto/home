# NixOS running inside Windows Subsystem for Linux
# build the tarball with:
#   sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
# then on windows: wsl --install --from-file nixos.wsl
{
  lib,
  pkgs,
  flakeSelf,
  ...
}:
{
  imports = [
    flakeSelf.inputs.nixos-wsl.nixosModules.default
    flakeSelf.nixosProfiles.nix-daemon
    flakeSelf.nixosProfiles.teto

    ./services/llamacpp.nix
    ./services/openssh.nix

    flakeSelf.nixosModules.default-hm
    flakeSelf.inputs.flyline.nixosModules.default
  ];

  programs.flyline.enable = true;

  wsl = {
    enable = true;
    defaultUser = "teto";
    startMenuLaunchers = true;
    wslConf.network.hostname = "wsl";
  };

  networking.hostName = "wsl";
  networking.domain = null;

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    git
    neovim
    systemctl-tui
    wget
    btop-cuda # for jedha
  ];

  home-manager.users.teto = {
    imports = [
      flakeSelf.homeProfiles.teto-aliases
      flakeSelf.homeProfiles.common
      flakeSelf.homeProfiles.neovim
      flakeSelf.homeProfiles.teto-zsh

      flakeSelf.homeModules.neovim
      ./hm-teto.nix
    ];
    home.stateVersion = "26.05";

    programs.neovim = {

      enableRocks = true;
      highlightOnYank = true;
      enableFzfLua = true;
      # enableBlink = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "26.05";
}
