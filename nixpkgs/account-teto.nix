{ config, pkgs, options, lib, ... }:
let 
  secrets = import ./secrets.nix;
in
{
  imports = [

    ./extraTools.nix
    # ./desktopPkgs.nix
  ];

  users.extraUsers.teto = {
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
       "jupyter" # for udiskie
       # "kvm" # don't think that's needed 
     ];
     # once can set initialHashedPassword too
     initialPassword = secrets.tetoInitialPassword;
	 shell = pkgs.zsh;
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
}
