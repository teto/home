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
  ports = [ 12666 ];

  # tu peux en avoir plusieurs sur ce mode
  # alors que on a 
  # AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u

  # # for sshfs edit or scp
  allowSFTP = true;

  startWhenNeeded = true;

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
