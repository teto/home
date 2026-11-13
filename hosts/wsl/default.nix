# NixOS running inside Windows Subsystem for Linux
# build the tarball with:
#   sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
# then on windows: wsl --install --from-file nixos.wsl
{
  lib,
  pkgs,
  flakeSelf,
  config,
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

  networking.hostName = lib.mkDefault "wsl";
  networking.domain = null;

  time.timeZone = "Europe/Paris";

  programs.flyline.enable = true;

  wsl = {
    enable = true;
    defaultUser = "teto";
    startMenuLaunchers = true;
    useWindowsDriver = true; # else "mkWslLib" use would complain
    wslConf.network.hostname = "wsl";
  };

  programs.nix-ld = {
    enable = true;
    libraries = [ config.wsl.wslLib ];
  };


  environment.systemPackages = with pkgs; [
    claude-code
    git
    neovim
    systemctl-tui
    wget
    btop-cuda # for jedha

    # vllm # broken on arm
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

    home.packages = [
      pkgs.ripgrep

    ];
  };

  # to test vllm
  virtualisation.docker = {

    enable = true;
    enableOnBoot = true;

    daemon.settings.features.cdi = true;

    # listenOptions = [
    # "0.0.0.0:80"
    # ];
    # logDriver =
    # liveRestore
  };

  # advice taken from https://github.com/nix-community/NixOS-WSL/pull/586/changes
  # to enable nvidia passtru in docker ?
  hardware.nvidia.package = config.wsl.wslLib;

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
    suppressNvidiaDriverAssertion = true;
    # disable-hooks = [];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "26.05";
}
