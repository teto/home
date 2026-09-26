  # Also provide Hickory's `dns` and `resolve` command-line clients.
{ config, lib, ... }:
{
settings.Resolve = {
  DNS = "127.0.0.1:53";
  #  no I dooont want it
  DNSStubListener = "no";
  # Specific routes win over DHCP search domains, including for .local aliases.
  # this overrides the default derived from networking.search !!!
  # NixOS uses networking.search only as the default for that option
  Domains = config.networking.search ++ [
    "~."
  ]
  ++ map (zone: "~${zone.zone}") (
    lib.filter (zone: zone.zone_type == "Primary") config.services.hickory-dns.settings.zones
  );
  ResolveUnicastSingleLabel = true;

  UseDomains = true;
  # Domains = [ ]; # does it use networking.domain ?

};

}
