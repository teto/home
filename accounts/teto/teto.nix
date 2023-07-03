{ config, pkgs, options, lib, ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;
in
{

  users.users.teto = {
    isNormalUser = true; # creates home/ sets default shell
    uid = 1000;
    extraGroups = [
      "audio" # for pulseaudio/pipewire
      "dialout" # to access serial devices like the conbee II
      "docker" # to access docker socket
      "input" # for libinput-gestures
      "libvirtd" # for nixops
      "networkmanager" # not necessary for nixpos
      "adbusers" # for android tools
      "wireshark"
      "plugdev" # for udiskie
      "jupyter"
      "video" # to control brightness
      "rtkit" # for pipewire
      "pipewire" # for pipewire
      "podman"
      "postgres"
      "pgadmin" # pgadmin is such a mess
      "wheel" # for sudo
      "vboxusers" # to avoid Kernel driver not accessible
      # "kvm" # don't think that's needed
      # config.users.groups.keys.name
      "keys"
    ];
    # once can set initialHashedPassword too
    # initialPassword
    # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
    hashedPassword = secrets.users.teto.hashedPassword;

    openssh.authorizedKeys.keyFiles = [
      ../../perso/keys/id_rsa.pub
    ];

    packages = with pkgs; [
      pciutils # for lspci
      ncdu # to see disk usage
      wirelesstools # to get iwconfig
      gitAndTools.diff-so-fancy
      # aircrack-ng
    ];

  };

  home-manager.users.teto = {
   imports = [ 
    ({ ... }: {   home.stateVersion = "23.05"; })
 
     # import only for desktop
     # (import ./ssh-config.nix)
   ];
  };

  nix.settings.trusted-users = [ "teto" ];
}