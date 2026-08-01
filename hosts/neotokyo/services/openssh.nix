{
  flakeSelf,
  lib,
  secrets,
  withSecrets,
  ...
}:
{
  _imports = [
    flakeSelf.nixosProfiles.openssh
  ];

    enable = true;
    ports = lib.mkIf withSecrets [ secrets.jakku.sshPort ];

    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # new format
    settings = {

      MaxAuthTries = 3;
      # LoginGraceTime = 500;
      Protocol = 2;
      ChallengeResponseAuthentication = false;
      AcceptEnv = [
        "GITHUB_TOKEN"
        "SOPS_AGE_SSH_PRIVATE_KEY_FILE"
      ];
      # LogLevel = "VERBOSE";
      LogLevel = lib.mkForce "DEBUG";
      KbdInteractiveAuthentication = false;
      # PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = lib.mkForce "no";

      # could not find it
      # HostKey = "/run/secrets/ssh_host_key";

      AllowUsers = [
        "teto"
        "gitolite" # depend on gitolite service
      ];
      # KexAlgorithms =
    };
}
