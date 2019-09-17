{ config, pkgs, options, lib, ... }:
let
  secrets = import ./secrets.nix;
in
{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"

  ];

  users.users.teto = {
     isNormalUser = true; # creates home/ sets default shell
     uid = 1000;
     extraGroups = [
       "audio" # for pulseaudio 
       "docker"   # to access docker socket
       "input"    # for libinput-gestures
       "libvirtd" # for nixops
       "networkmanager" # not necessary for nixpos
       "adbusers" # for android tools
       "wireshark"
       "plugdev" # for udiskie
       "jupyter"
       "video" # to control brightness
       "wheel" # for sudo
       # "kvm" # don't think that's needed 
     ];
     # once can set initialHashedPassword too
     # initialPassword 
     # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
     hashedPassword = "$6$T/5zYuCMI$U45oW0D6cPKsXtETwlNFpsit924HElAYtXPsGTpj0XS/ITUz39xpPxnL.kzUWqeqQmRxvEOAHBeKm5/xHDrvs1";


     openssh.authorizedKeys.keyFiles = [ ./keys/iij_rsa.pub ];

     packages = with pkgs; [
       pciutils # for lspci
       ncdu  # to see disk usage
       bridge-utils # pour  brctl
       wirelesstools # to get iwconfig
       gitAndTools.diff-so-fancy
        # aircrack-ng
      ];

  };

  # TODO find a way to accomplish this
  nix.trustedUsers = ["teto"];
  # TODO add a group teto ?

  # kinda experimental
  # see https://github.com/rycee/home-manager/issues/252 for why it should be a function
  # home-manager.users.teto = { ... }:
  # {
    # fails for now
    # imports = [ ./home-common.nix ];
  # };
}
