{ config, pkgs, options, lib, ... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;
in
{

 imports = [
   ../../profiles/zsh.nix
  ];
  users.users.teto = {

    shell = pkgs.zsh;

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
      "kvm" # needed when using runAsRoot when building dockerImage
      # config.users.groups.keys.name
      "keys"
     ] ++  lib.optional (config.services.kanata.enable)

      "uinput" # required for kanata it seems
     ;
    # once can set initialHashedPassword too
    # initialPassword
    # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
    # hashedPassword = secrets.users.teto.hashedPassword;
hashedPassword = "$6$UcKAXNGR1brGF9S4$Xk.U9oCTMCnEnN5FoLni1BwxcfwkmVeyddzdyyHAR/EVXOGEDbzm/bTV4F6mWJxYa.Im85rHQsU8I3FhsHJie1";

    openssh.authorizedKeys.keyFiles = [
      ../../../perso/keys/id_rsa.pub
    ];

    packages = with pkgs; [
      ncdu # to see disk usage
    ];
  };

  nix.settings.trusted-users = [ "teto" ];
}
