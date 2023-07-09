{ config, lib, pkgs, ... }:
{

  services.openldap.enable = true;
  # LDIF format
  # services.openldap.declarativeContents = 
  # services.openldap.extraConfig
  # slapd.conf configuration
}

