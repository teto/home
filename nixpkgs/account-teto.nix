{ config, pkgs, options, lib, ... }:
let 
  secrets = import ./secrets.nix;
in
{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"

    ./extraTools.nix
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

     # import basetools
     # packages = with pkgs; [
     #   (import ./extraTools.nix)
     #   # termite sxiv
     # ];

     # openssh.authorizedKeys.keyFiles = [ ./keys/iij_rsa.pub ];
     # openssh.authorizedKeys.keys = 
  };

  # TODO add a group teto ?

  # kinda experimental
  # see https://github.com/rycee/home-manager/issues/252 for why it should be a function
  # home-manager.users.teto = { ... }:
  # {
    # fails for now
    # imports = [ ./home-common.nix ];
  # };
}
