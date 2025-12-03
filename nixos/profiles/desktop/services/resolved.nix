{ config, ... }:
{
  # conflicts with adguardhome
  enable = !config.services.adguardhome.enable;
  dnssec = "false"; # "allow-downgrade";
}
