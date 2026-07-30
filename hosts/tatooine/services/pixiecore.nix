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
  # systemd.services.jellyfin.wantedBy = lib.mkForce [ ];

}
