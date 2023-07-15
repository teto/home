{ config, pkgs, lib, secrets, ... }:
{
  imports = [
    ../../nixos/profiles/openssh.nix
  ];

  services.openssh = {
    banner = "You can start the nextcloud-add-user.service unit if teto user doesnt exist yet";

   ports = [ secrets.jakku.sshPort ];

   # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # new format
    settings = {
      LogLevel = "VERBOSE";
      KbdInteractiveAuthentication = false;
      # PasswordAuthentication = false;
	  X11Forwarding = false;
      PermitRootLogin = lib.mkForce "no";
    };
  };
}
