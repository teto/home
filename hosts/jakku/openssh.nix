{ config, pkgs, lib, secrets, ... }:
{
  imports = [
    ../../nixos/profiles/openssh.nix
   ];

  services.openssh = {
   ports = [ secrets.jakku.sshPort ];

   settings = {
     PermitRootLogin = lib.mkForce "no";
	};
  };
}
