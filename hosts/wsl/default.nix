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

    flakeSelf.nixosModules.default-hm
  ];

  wsl = {
    enable = true;
    defaultUser = "teto";
    startMenuLaunchers = true;
    wslConf.network.hostname = "wsl";
  };

  networking.hostName = "wsl";
  networking.domain = null;

  time.timeZone = "Europe/Paris";

  # mirrors tatooine (desktop profile + host overrides)
  # keys come from nixos/users/teto/teto.nix
  services.openssh = {
    enable = true;
    ports = [ 12666 ];
    # for sshfs edit or scp
    allowSFTP = true;
    startWhenNeeded = true;
    settings = {
      LogLevel = "VERBOSE";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
  ];

  home-manager.users.teto = {
    imports = [
      flakeSelf.homeProfiles.teto-aliases
      flakeSelf.homeProfiles.common
      flakeSelf.homeProfiles.neovim
      flakeSelf.homeProfiles.teto-zsh
    ];
    home.stateVersion = "26.05";
  };

  programs.neovim = {

    enableRocks = true;
    highlightOnYank = true;
    enableFzfLua = true;
  };

  system.stateVersion = "26.05";
}
