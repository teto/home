{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{

  _imports = [
    flakeSelf.nixosProfiles.pixiecore

  ];
  enable = true;
  port = 8089;

  dhcpNoBind = true; # Use systemd-networkd's DHCP server on enp1s0f0.
  # systemd.services.jellyfin.wantedBy = lib.mkForce [ ];

}
