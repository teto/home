  # Also provide Hickory's `dns` and `resolve` command-line clients.
{ config, lib, ... }:
{
settings.Resolve = {
  DNS = "127.0.0.1:53";
  # 
  DNSStubListener = lib.mkForce "yes";
  # Specific routes win over DHCP search domains, including for .local aliases.
  Domains = [
    "~."
  ]
  ++ map (zone: "~${zone.zone}") (
    lib.filter (zone: zone.zone_type == "Primary") config.services.hickory-dns.settings.zones
  );
  ResolveUnicastSingleLabel = true;
};

}
