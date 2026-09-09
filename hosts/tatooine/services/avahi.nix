{
  flakeSelf,
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


  # enable-wide-area= Takes a boolean value ("yes" or "no"). Enable wide-area DNS-SD, aka
  # DNS-SD over unicast DNS. If this is enabled only domains ending in .local will be re‐
  # solved on mDNS, all other domains are resolved via unicast DNS. I

  settings = {

    # server = {
    #   # Set the host name avahi-daemon tries to register on the LAN. If omited defaults to the system host name as set with the sethostname() system call.
    #   # secrets.jedha.hostname;
    #   # host-name = "jedha";
    #   # enable-dbus = true;
    #
    # };
  };

  browseDomains = [ ];
  # /etc/mdns.allow
  ipv6 = false; # bug with multiple hostnames
  nssmdns4 = true;
  # allows to resolve for other domains such as .lan / .home
  nssmdnsFull = true;
  openFirewall = true;
  # services.avahi.settings.server.browse-domains

  publish = {
    enable = true;
    workstation = true;
    domain = true;
    addresses = true;
    # publish-a-on-ipv6 = false;
  };

}

