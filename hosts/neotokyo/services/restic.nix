{

  services.restic = {
    enable = false;
    backups = {
    # from doc
                 # commandbackup = {
                 #   command = [
                 #     "\${lib.getExe pkgs.sudo}"
                 #     "-u postgres"
                 #     "\${pkgs.postgresql}/bin/pg_dumpall"
                 #   ];
                 #   environmentFile = "/etc/nixos/secrets/restic-environment";
                 #   extraBackupArgs = [
                 #     "--tag database"
                 #   ];
                 #   passwordFile = "/etc/nixos/secrets/restic-password";
                 #   pruneOpts = [
                 #     "--keep-daily 14"
                 #     "--keep-weekly 4"
                 #     "--keep-monthly 2"
                 #     "--group-by tags"
                 #   ];
                 #   repository = "s3:example.com/mybucket";
                 # };
                 # localbackup = {
                 #   exclude = [
                 #     "/home/*/.cache"
                 #   ];
                 #   initialize = true;
                 #   passwordFile = "/etc/nixos/secrets/restic-password";
                 #   paths = [
                 #     "/home"
                 #   ];
                 #   repository = "/mnt/backup-hdd";
                 # };
                 # remotebackup = {
                 #   extraOptions = [
                 #     "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
                 #   ];
                 #   passwordFile = "/etc/nixos/secrets/restic-password";
                 #   paths = [
                 #     "/home"
                 #   ];
                 #   repository = "sftp:backup@host:/backups/home";
                 #   timerConfig = {
                 #     OnCalendar = "00:05";
                 #     RandomizedDelaySec = "5h";
                 #   };
                 # };
               };
  };

}

