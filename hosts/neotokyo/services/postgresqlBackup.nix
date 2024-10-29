{ config, ... }:
{
  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* *:15:00";
    pgdumpOptions = "--no-owner";

    # generate systemd services called "postgresqlBackup-${db}"
    databases = [
      config.services.immich.database.name
    ];

    # services.postgresqlBackup.location
    # Path of directory where the PostgreSQL database dumps will be placed.
    # Default: "/var/backup/postgresql"
  };
}
