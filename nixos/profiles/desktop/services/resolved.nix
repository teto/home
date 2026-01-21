{ config, ... }:
{
  # conflicts with adguardhome
  enable = !config.services.adguardhome.enable;

  settings.Resolve.DNSSEC = "false"; # "allow-downgrade";
}
