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
    # Domains = [ ]; # networking.domain

    # TODO fallback on
    # man resolved.conf
    FallbackDNS = [
      # we could use _gateway (solved by mymachines ?) depending on the order in nsswitch
      "192.168.1.254"
    ];

    # this is windows resolution system
    LLMNR = false; # blocks .local ?
    # ReadEtcHosts=no,
  };

  # "resolve";

  #  *.dns-delegate files may be used to delegate DNS lookups in specific domains to specific DNS servers. See "systemd.dns-delegate"
  # thus I should run a DNS server on local network for jedha stuff and so on
  # services.resolved.dnsDelegates.jedha-home = {
  #   Delegate = {
  #     DNS = delegateAddress;
  #     Domains = [ "jedha.home" ];
  #   };
  #
}
