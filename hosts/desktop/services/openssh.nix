{
  config,
  pkgs,
  lib,
  ...
}:
{

  enable = false;
  # kinda experimental
  ports = [ 12666 ];

  # tu peux en avoir plusieurs sur ce mode
  # alors que on a 
  # AuthorizedKeysFile %h/.ssh/authorized_keys %h/.ssh/authorized_keys2 /etc/ssh/authorized_keys.d/%u
  # hostKeys = [
  # {
  # bits = 4096;
  # path = "/etc/ssh/ssh_host_rsa_key";
  # type = "rsa";
  # }
  # {
  # path = "/run/secrets/";
  # type = "ed25519";
  # }
  # ];

  # # for sshfs edit or scp
  allowSFTP = true;

  startWhenNeeded = true;

  # hostKeys = [ ];

  # settings.HostKey = "/run/secrets/ssh_host_key";

  # testing https://github.com/NixOS/nixpkgs/pull/215397
  settings = {
    LogLevel = "VERBOSE";
    # kbdInteractiveAuthentication = false;
    KbdInteractiveAuthentication = false;
    PasswordAuthentication = false;
    PermitRootLogin = "no";
    X11Forwarding = false;
    # AuthorizedKeysCommandUser = "toto";
    # AuthorizedKeysFiles = ["tata" "toto"];
    # AuthorizedKeysCommandUser = "toto";
  };

}
