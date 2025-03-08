{
  ...
}:
{

  enable = false;
  # kinda experimental
  ports = [ 12666 ];

  # # for sshfs edit or scp
  allowSFTP = true;
  # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
  # needed since default is true !
  # listenAddresses = [
  #   { addr = "0.0.0.0"; port = 64022; }
  # ];

  hostKeys = [
    {
      type = "rsa";
      bits = 4096;
      path = "/etc/ssh/ssh_host_rsa_key";
    }
    {
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
    }
  ];

  # startWhenNeeded = true;

  # extraConfig = ''
  # HostKey /home/teto/.ssh/server_id_rsa
  # '';

  # authorizedKeysFiles = [
  #   "~/.ssh/id_rsa.pub"
  # ];
  # authorizedKeys = { }

  # new format
  # settings = {
  # };

  # kbdInteractiveAuthentication = false;
  # logLevel = "VERBOSE";
  # permitRootLogin = "prohibit-password";
  # passwordAuthentication = false;
  # };
}
