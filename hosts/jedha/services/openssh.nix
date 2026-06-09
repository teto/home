{
  config,
  pkgs,
  lib,
  ...
}:
{
  _imports = [

    # {
    #   # disable autostart
    #   systemd.services.openssh.wantedBy = lib.mkForce [ ];
    # }
    # )
  ];

  enable = true;
  # kinda experimental

  # settings.HostKey = "/run/secrets/ssh_host_key";

}
