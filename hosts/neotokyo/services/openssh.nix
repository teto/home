{
  flakeSelf,
  lib,
  secrets,
  ...
}:
{
  imports = [
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

      MaxAuthTries = 3;
      # LoginGraceTime = 500;
      Protocol = 2;
      ChallengeResponseAuthentication = false;
      AcceptEnv = [ "GITHUB_TOKEN" ];
      # LogLevel = "VERBOSE";
      LogLevel = lib.mkForce "DEBUG";
      KbdInteractiveAuthentication = false;
      # PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = lib.mkForce "no";
      HostKey = "/run/secrets/ssh_host_key";

      AllowUsers = [
        "teto"
        "gitolite"
      ];
      # KexAlgorithms =
    };
  };
}
