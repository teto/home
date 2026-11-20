{
  flakeSelf,
  ...
}:
{
  _imports = [
    flakeSelf.nixosProfiles.avahi
  ];

  enable = true;
  openFirewall = true;
  debug = true;

  # allowInterfaces = [
  #   "wlp10s0"
  # wlp2s0
  # enp1s0f0
  # ];

  # enable-wide-area= Takes a boolean value ("yes" or "no"). Enable wide-area DNS-SD, aka
  # DNS-SD over unicast DNS. If this is enabled only domains ending in .local will be re‐
  # solved on mDNS, all other domains are resolved via unicast DNS. I

  settings = {
    publish = {
      publish-domain = true;
      disable-publishing = false;
      disable-user-service-publishing = false;
      # for reverse lookups
      publish-addresses = true;
    };

    server = {
      use-ipv6 = false; # bug with multiple hostnames
      allow-interfaces = ["enp1s0f0" "wlp2s0" ];
      #   # Set the host name avahi-daemon tries to register on the LAN. If omited defaults to the system host name as set with the sethostname() system call.
      #   # secrets.jedha.hostname;
      #   # host-name = "jedha";
      #   # enable-dbus = true;
      #
    };
  };

  # /etc/mdns.allow
  nssmdns4 = true;
  # allows to resolve for other domains such as .lan / .home
  nssmdnsFull = false;
  # services.avahi.settings.server.browse-domains

  # publish = {
  #   enable = true;
  #   workstation = true;
  #   domain = true;
  #   addresses = true;
  #   # publish-a-on-ipv6 = false;
  # };

}
