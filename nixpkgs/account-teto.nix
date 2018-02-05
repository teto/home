{ config, pkgs, options, lib, ... }:
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
       "networkmanager"
       "libvirtd" # for nixops
       "adbusers" # for android tools
       "wireshark"
       "plugdev" # for udiskie
       # "kvm" # don't think that's needed 
     ];
     # once can set initialHashedPassword too
     initialPassword = "test";
	 shell = pkgs.zsh;
     # TODO import it from desktopPkgs for instance ?
     # import basetools
     # packages = with pkgs; [
     #   (import ./extraTools.nix)
     #   # termite sxiv
     # ];

     openssh.authorizedKeys.keyFiles = [ "keys/iij_rsa.pub" ];
     # openssh.authorizedKeys.keys = 
  };
}
