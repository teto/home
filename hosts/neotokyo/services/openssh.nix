{
  flakeSelf,
  lib,
  secrets,
  ...
}:
{
  imports = [
    # ../../../nixos/profiles/openssh.nix
    flakeSelf.nixosProfiles.openssh
  ];

  services.openssh = {

    enable = true;
    ports = [ secrets.jakku.sshPort ];

    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # new format
    settings = {
      # LogLevel = "VERBOSE";
      LogLevel = lib.mkForce "DEBUG";
      KbdInteractiveAuthentication = false;
      # PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = lib.mkForce "no";
      HostKey = "/run/secrets/ssh_host_key";
    };
  };
}
