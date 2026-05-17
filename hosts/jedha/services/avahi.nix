{
  enable = true;
  # allowInterfaces = [ 
  #   "wlp10s0"
  # ];
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
