{
  config,
  pkgs,
  lib,
  ...
}:
{
  _imports = [

    # ({...}:
    #
    # {
    #   # disable autostart
    #   systemd.services.openssh.wantedBy = lib.mkForce [ ];
    # }
    #
    # )
  ];

  enable = true;
  # kinda experimental

  # settings.HostKey = "/run/secrets/ssh_host_key";

  # testing https://github.com/NixOS/nixpkgs/pull/215397
  # settings = {
  #   LogLevel = "VERBOSE";
  #   # kbdInteractiveAuthentication = false;
  #   KbdInteractiveAuthentication = false;
  #   PasswordAuthentication = false;
  #   PermitRootLogin = "no";
  #   X11Forwarding = false;
  #   # AuthorizedKeysCommandUser = "toto";
  #   # AuthorizedKeysFiles = ["tata" "toto"];
  #   # AuthorizedKeysCommandUser = "toto";
  # };

}
