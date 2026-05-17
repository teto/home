{ config, ... }:
{
  # conflicts with adguardhome
  enable = !config.services.adguardhome.enable;

  # ideally set it to false ?
  settings.Resolve.DNSSEC = "false"; # "allow-downgrade";

  # MulticastDNS=
  #   Takes  a  boolean argument or "resolve". Controls Multicast DNS support (RFC 6762[3])
  #   on the local host. If true, enables full Multicast DNS responder  and  resolver  sup‐
  #   port.  If  false,  disables both. If set to "resolve", only resolution support is en‐
  #   abled, but responding is disabled. Note that systemd-networkd.service(8)  also  main‐
  #   tains  per-link  Multicast DNS settings. Multicast DNS will be enabled on a link only
  settings.Resolve.MulticastDNS = "resolve";

  # resolved exposes a stub listener at "127.0.0.53"
  # DNSStubListener=

  # TODO fallback on
  # man resolved.conf
  settings.Resolve.FallbackDNS = [ ];
  # MulticastDNS
  # ReadEtcHosts=no,
  # services.resolved.dnsDelegates.example-org = {
  #   Delegate = {
  #     DNS = delegateAddress;
  #     Domains = [ "delegated.example.org" ];
  #   };
  #
}
