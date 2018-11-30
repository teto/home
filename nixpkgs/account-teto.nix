{ config, pkgs, options, lib, ... }:
let 
  secrets = import ./secrets.nix;
in
{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"

    ./extraTools.nix
    # ./desktopPkgs.nix
  ];

  users.users.teto = {
     isNormalUser = true; # creates home/ sets default shell
     uid = 1000;
     extraGroups = [
       "audio" # for pulseaudio 
       "wheel" # for sudo
       "networkmanager" # not necessary for nixpos
       "libvirtd" # for nixops
       "adbusers" # for android tools
       "wireshark"
       "plugdev" # for udiskie
       "jupyter"
       "docker"   # to access docker socket
       # "kvm" # don't think that's needed 
     ];
     # once can set initialHashedPassword too
     initialPassword = secrets.tetoInitialPassword;

     # TODO import it from desktopPkgs for instance ?
     # import basetools
     # packages = with pkgs; [
     #   (import ./extraTools.nix)
     #   # termite sxiv
     # ];

     openssh.authorizedKeys.keyFiles = [ ./keys/iij_rsa.pub ];
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
