{ config, ... }:
{
    enable = true;
    startAt = "*-*-* *:15:00";
    pgdumpOptions = "--no-owner";
    databases = 
    [
      config.services.immich.database.name
    ];
}
