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

  systemd.services.immich-server.serviceConfig = {
    # we override the default 0077 such that the backup job can read the files
    UMask = lib.mkForce "0027";
  };

  # TODO add onFailure template to send a mail
  systemd.services.restic-backups-immich-db-to-backblaze =
    lib.mkIf (config.services.restic.backups ? immich-db-to-backblaze)
      {
        serviceConfig = {
          Group = "immich"; # such that it can read the files (but can not write to it)
          # Type = "exec"; # restic sets it to "oneshot"
          RemainAfterExit = "yes";
        };
        unitConfig = {
          PartOf = "restic-backups-immich-db-to-backblaze.timer";
          # todo pass failure
          OnSuccess = "send-mail-to-teto@success.service";
          OnFailure = "send-mail-to-teto@failure.service";
        };
      };
}
