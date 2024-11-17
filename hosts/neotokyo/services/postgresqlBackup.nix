/**
  there is a lot to say about backups
  - https://thenegation.com/posts/nixos-pg-archives/
  - https://notes.abhinavsarkar.net/2023/mastodon-backup
*/
{
  config,
  pkgs,
  secrets,
  ...
}:
let
  dbName = config.services.immich.database.name;
in
{
  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* *:15:00";
    pgdumpOptions = "--no-owner -v";

    # generate systemd services called "postgresqlBackup-${db}"
    databases = [
      # https://immich.app/docs/administration/backup-and-restore
      dbName
    ];

    # Path of directory where the PostgreSQL database dumps will be placed.
    # Default: "/var/backup/postgresql"
    # location = "";

    # serviceConfig = 
  };

  # see TMPFILES.D(5)
  systemd.tmpfiles.rules = [
    # "d '${cfg.location}' 0700 postgres - - -"

    # 'backup' group hasread access only
    # 0740 would be better but for now just make it work
    # TODO check if this takes precedence over postgresqlBackup tmpfiles
    "d '/var/backup/postgresql' 0750 postgres backup - -"
  ];

  # mv ${encBackupFileLocation} ${backupDir}/ && \

  systemd.services."postgresqlBackup-${dbName}".serviceConfig = {
    # script = pkgs.writeShellScriptBin "pg-db-archive" ''

    # change the owner so that the restic job can read the file and back it up
    ExecStartPost = pkgs.writeShellScript "pg-db-archive" ''
      ## Define the backup directory path:
      set -x
      _dirBackup="${config.services.postgresqlBackup.location}"

      echo "assigning group to $_dirBackup"
      # does it have the right ? immich.sql.gz
      chgrp -R "backup" "/var/backup/postgresql"
      echo "Changing permissions"
    '';
    # # TODO ideally we could change it to 440 ?
    # chmod -R 640 "/var/backup/postgresql"
  };

  # systemd.tmpfiles.rules = [
  #   "z ${syncthingCfg.dataDir} 0750 ${syncthingCfg.user} ${syncthingCfg.group}"
  #   "d ${backupDir} 0775 ${syncthingCfg.user} ${syncthingCfg.group}"
  #   "z ${mastodonFilesDir} 0770 ${mastodonCfg.user} ${mastodonCfg.group}"
  #   "z ${backupEncPassphraseFile} 400 postgres postgres"
  # ];

  # if you want to get a notification 
  # https://www.arthurkoziel.com/restic-backups-b2-nixos/
  services.restic.backups = {
    immich-db-to-backblaze = {
      # under which user to run. Defaults to root
      user = "teto";
      extraOptions = [
        # "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
      ];

      # that's where our provider (backblaze) credentials go 
      environmentFile = "/var/run/secrets/restic/backblaze_backup_immich_credentials";
      # this is the restic password
      passwordFile = "/var/run/secrets/restic/backup_immich_repo_password";
      paths =
        let
          # depends on "IMMICH_MEDIA_LOCATION=/var/lib/immich"
          UPLOAD_LOCATION = "/var/lib/immich";
        in
        [
          # backup of the immich DB generated by services.postgresqlBackup 
          "/var/backup/postgresql"

          # backup of immich data (not generated)
          # see https://immich.app/docs/administration/backup-and-restore#filesystem
          "${UPLOAD_LOCATION}/library"
          "${UPLOAD_LOCATION}/profile"
          "${UPLOAD_LOCATION}/upload"
        ];
      # pruneOpts = [
      #   "--keep-daily 7"
      #   "--keep-weekly 4"
      #   "--keep-monthly 2"
      #   "--keep-yearly 0"
      # ];

      # repository = "sftp:backup@host:/backups/home";
      # s3 ?

      # backupPrepareCommand = "${pkgs.restic}/bin/restic unlock";
      createWrapper = true;
      initialize = true; # create restic repo if it doesn't exist
      # could we check the service at buildtime ?
      repository = "${secrets.backblaze.immich-backup-bucket}";

      # outdated it seems ?
      # repository = "b2:backup-immich-matt";
      # repositoryFile
      timerConfig = {
        # daily
        OnCalendar = "03:00";
        RandomizedDelaySec = "1h";
        # OnUnitActiveSec = "1d";

        # Persistent = true;
        # NB: the option Persistent=true triggers the service
        # immediately if it missed the last start time
      };
    };
  };

  # services.restic.server.enable
  #      Whether to enable Restic REST Server.

  sops.secrets = {
    "restic/backblaze_backup_immich_credentials" = {
      mode = "440";
      # path = "%r/github_token";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;
    };

    "restic/endpoint" = {
      mode = "440";
      # path = "%r/github_token";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;
    };

    "restic/backup_immich_repo_password" = {
      mode = "440";
      owner = config.users.users.teto.name;
      group = config.users.users.teto.group;
    };
  };
}
