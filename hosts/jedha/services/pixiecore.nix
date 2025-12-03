{
  config,
  lib,
  pkgs,
  ...
}:
{

  enable = true;
  port = 8089;
  # systemd.services.jellyfin.wantedBy = lib.mkForce [ ];

}
