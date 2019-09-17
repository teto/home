{ config, lib, pkgs,  ... }:
{
    # thanks to clever
    # https://github.com/cleverca22/not-os/blob/master/runit.nix#L62-L66
    # https://github.com/cleverca22/not-os/blob/d55aa5ca2d3795d7151ac8a4099c79bf506a2aa4/qemu.nix#L4
    systemd.services.hwrng = {
      # after = [ "network.target" "sound.target" ];
      description = "Hardware generator ";
      # eventually sshd ?
      # wantedBy = optional (!cfg.startWhenNeeded) "multi-user.target";

      serviceConfig = {
        # User = "${cfg.user}";
        # pkgs.writeScript "rngd" ''
        ExecStart = ''${pkgs.rng_tools}/bin/rngd -r /dev/hwrng'';
        # Type = "notify";
        # LimitRTPRIO = 50;
        # LimitRTTIME = "infinity";
        # ProtectSystem = true;
        # NoNewPrivileges = true;
        # ProtectKernelTunables = true;
        # ProtectControlGroups = true;
        # ProtectKernelModules = true;
        # RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
        # RestrictNamespaces = true;
      };
    };
}
