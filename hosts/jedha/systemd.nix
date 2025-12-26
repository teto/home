{ lib, ... }:
{

  services.pixiecore.wantedBy = lib.mkForce [ ];

  # you can try this at runtime
  # systemctl service-log-level systemd-networkd debug
  services.systemd-tmpfiles-setup.serviceConfig = {
    LogLevelMax = "debug"; # or "info" for less verbose output
  };
}
