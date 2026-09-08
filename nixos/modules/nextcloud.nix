{
  config,
  lib,
  ...
}:
let
  cfg = config.services.nextcloud;
  inherit (cfg) datadir occ;
in
{

  options = {
    services.nextcloud = {
      previewGenerator = lib.mkEnableOption "preview generator";

    };
    # occ memories:places-setup    # set up reverse geocoding, will force re-indexing
    # occ memories:index

  };
  # 'preview_max_x' => 2048,
  # 'preview_max_y' => 2048,

  # see https://memories.gallery/config/
  # 'preview_max_memory' => 4096,
  # 'preview_max_filesize_image' => 256,

  # "opcache.interned_strings_buffer" = "8";
  # "opcache.max_accelerated_files" = "10000";
  # "opcache.memory_consumption" = "128";
  # "opcache.revalidate_freq" = "15";
  # "opcache.fast_shutdown" = "1";
  # config:system:set maintenance_window_start --value="1" --type=integer
  config = lib.mkMerge [
    (lib.mkIf cfg.previewGenerator {

      # TODO add it to extraApps
      systemd.timers.nextcloud-previewgenerator-cron = {
        wantedBy = [ "timers.target" ];
        after = [ "nextcloud-setup.service" ];
        timerConfig.OnBootSec = "5m";
        timerConfig.OnUnitActiveSec = "10m";
        timerConfig.Unit = "nextcloud-previewgenerator-cron.service";
      };

      systemd.services.nextcloud-previewgenerator-cron = {
        after = [ "nextcloud-setup.service" ];
        environment.NEXTCLOUD_CONFIG_DIR = "${datadir}/config";
        serviceConfig.Type = "oneshot";
        serviceConfig.User = "nextcloud";
        # Run ./occ preview:generate-all once after installation.
        # Add a (system) cron job for  ./occ preview:pre-generate     # preview:generate-all

        # we could even be more verbose with -vvv
        serviceConfig.ExecStart = "${occ}/bin/nextcloud-occ preview:generate-all -vv";
      };

    })

  ];
}
