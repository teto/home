/*
  You will notice the difference when trying to add network printers in the CUPS admin webpage. CUPS will auto-detect printers with avahi but not with systemd-resolved.

  man systemd.dnssd
*/
# { config, ... }:
{
  # conflicts with adguardhome
  # enable = !config.services.adguardhome.enable;
  enable = true;

  # ideally set it to false ?
  settings.Resolve = {
    DNSSEC = "no"; # "allow-downgrade";
    # conflicts with avahi
    MulticastDNS = true;
    DNS = "127.0.0.1:53"; # defer to adguardhome ? port
    # Domains=~.
    # if "yes" resolved exposes a stub listener at "127.0.0.53"
    # but resolv.conf settings are tailored for the sub listener !
    DNSStubListener = "no";
    # use the ones obtained by dhcp ?
    UseDomains = true;
    # Domains = [ "local" ]; # networking.domain

    # TODO fallback on
    # man resolved.conf
    FallbackDNS = [
      # we could use _gateway (solved by mymachines ?) depending on the order in nsswitch
      "192.168.1.254"
    ];

    # this is windows resolution system
    LLMNR = true; # blocks .local ?
    # ReadEtcHosts=no,
  };

  # MulticastDNS=
  #   Takes  a  boolean argument or "resolve". Controls Multicast DNS support (RFC 6762[3])
  #   on the local host. If true, enables full Multicast DNS responder  and  resolver  sup‐
  #   port.  If  false,  disables both. If set to "resolve", only resolution support is en‐
  #   abled, but responding is disabled. Note that systemd-networkd.service(8)  also  main‐
  #   tains  per-link  Multicast DNS settings. Multicast DNS will be enabled on a link only
  # "resolve";
  # services.resolved.dnsDelegates.example-org = {
  #   Delegate = {
  #     DNS = delegateAddress;
  #     Domains = [ "delegated.example.org" ];
  #   };
  #
}
