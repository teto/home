{
  flakeSelf,
  # withSecrets, secrets
  ...
}:
{
  _imports = [
    flakeSelf.nixosProfiles.avahi
  ];

  enable = false;

  openFirewall = true;

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
      browse-domains = [ ];
      use-ipv6 = false; # bug with multiple hostnames
    };

    publish = {
        disable-publishing = false;
        disable-user-service-publishing = false;
        publish-addresses = true;
      };

    };


  nssmdns4 = true;
  # publish = {
  #   enable = true;
  #   workstation = true;
  #   domain = true;
  #   addresses = true;
  #   # publish-a-on-ipv6 = false;
  # };

}
