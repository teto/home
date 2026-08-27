{
  config,
  lib,
  secrets,
  # withSecrets,
  # , secretsFolder
  ...
}:
{
  # enable = true;
  # TODO create folders for transmission/jellyfin in /media or /home/media
  tmpfiles.rules = [
    # "d '${cfg.location}' 0700 postgres - - -"

    # 'backup' group hasread access only
    # 0740 would be better but for now just make it work
    # TODO check if this takes precedence over postgresqlBackup tmpfiles
    # "d '/var/backup/postgresql' 0750 postgres backup - -"

    "d /var/www 0775 nginx www"
    "d /var/www/blog-generated 0775 nginx www"
  ];

  # what's the diff with networking.useNetworkd ?
  network = {
    enable = true;

    networks."50-wg0" = {
      networkConfig = {
        # do not use IPMasquerade,
        # unnecessary, causes problems with host ipv6
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };

    # https://wiki.nixos.org/wiki/WireGuard#Peer_setup
    # networks."50-wg0" = {
    #   matchConfig.Name = "wg0";
    #
    #   address = [
    #     # /32 and /128 specifies a single address
    #     # for use on this wg peer machine
    #     "fd31:bf08:57cb::7/128"
    #     "192.168.26.7/32"
    #   ];
    # };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        # ensure file is readable by `systemd-network` user
        PrivateKeyFile = config.sops.secrets.wg-private-key.path;

        # To automatically create routes for everything in AllowedIPs,
        # add RouteTable=main
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0
        # with the number 42, which can be used to define policy rules on these packets.
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          # todo set the peer public key ?
          PublicKey = "HPrWcZUuJMsxc+qDrN08IC9GJoy/c1UofmvmTC/bm3U=";

          # Each peer can handle traffic destined for a certain IP range. This range is called AllowedIP.
          AllowedIPs = [
            "10.100.0.0/24"
          ];
          # Endpoint = "192.168.1.26:51820";

          # RouteTable can also be set in wireguardPeers
          # RouteTable in wireguardConfig will then be ignored.
          # RouteTable = 1000;
        }
      ];
    };
  };

  services.nextcloud-add-user = {
    path = [ config.services.nextcloud.occ ];
    script = ''
      export OC_PASS="$(cat ${config.sops.secrets."nextcloud/tetoPassword".path})"
      nextcloud-occ user:add --password-from-env teto
      ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting teto settings email "${secrets.users.teto.email}"
    '';
    # ${config.services.nextcloud.occ}/bin/nextcloud-occ user:setting admin settings email "admin@localhost"
    serviceConfig = {
      Type = "oneshot";
      User = "nextcloud";
    };
    # DONT run it automatically
    # after = [ "nextcloud-setup.service" ];

    # see https://discourse.nixos.org/t/disable-a-systemd-service-while-having-it-in-nixoss-conf/12732
    wantedBy = lib.mkForce [ ];
  };

  # TODO condition on immich
  services.immich-server.serviceConfig = {
    # we override the default 0077 such that the backup job can read the files
    UMask = lib.mkForce "0027";
  };

  services.restic-backups-immich-db-to-backblaze =
    lib.mkIf (config.services.restic.backups ? immich-db-to-backblaze)
      {
        serviceConfig = {
          Group = "immich"; # such that it can read the files (but can not write to it)
          # Type = "exec"; # restic sets it to "oneshot"
          # RemainAfterExit = "yes"; # might break the job enqueuing ?
        };
        unitConfig = {
          PartOf = "restic-backups-immich-db-to-backblaze.timer";
          # todo pass failure
          OnSuccess = "send-mail-to-teto@success.service";
          OnFailure = "send-mail-to-teto@failure.service";
        };
      };

}
