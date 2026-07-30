/**
  there is a lot to say about backups
  - https://thenegation.com/posts/nixos-pg-archives/
  - https://notes.abhinavsarkar.net/2023/mastodon-backup
*/
{
  config,
  # pkgs,
  # secrets,
  lib,
  ...
}:
# let
# dbName = config.services.immich.database.name;
# in
{
  # systemd.tmpfiles.rules = [
  #   "z ${syncthingCfg.dataDir} 0750 ${syncthingCfg.user} ${syncthingCfg.group}"
  #   "d ${backupDir} 0775 ${syncthingCfg.user} ${syncthingCfg.group}"
  #   "z ${mastodonFilesDir} 0770 ${mastodonCfg.user} ${mastodonCfg.group}"
  #   "z ${backupEncPassphraseFile} 400 postgres postgres"
  # ];

  # TODO add onFailure template to send a mail
  # systemd.services.
}
