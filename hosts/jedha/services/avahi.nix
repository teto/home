{
  flakeSelf,
  # withSecrets, secrets
  ...
}:
{
  _imports = [
    flakeSelf.nixosProfiles.avahi
  ];

  enable = true;

  debug = true;

  # allowInterfaces = [
  #   "wlp10s0"
  # ];

  settings = {

    server = {
      # Set the host name avahi-daemon tries to register on the LAN. If omited defaults to the system host name as set with the sethostname() system call.
      # secrets.jedha.hostname;
      host-name = "jedha";
      # enable-dbus = true;

    };
  };

  browseDomains = [ ];

  ipv6 = false; # bug with multiple hostnames
  nssmdns4 = true;
  openFirewall = true;
  publish = {
    enable = true;
    workstation = true;
    domain = true;
    addresses = true;
    # publish-a-on-ipv6 = false;
  };

}
