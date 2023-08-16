{ config, secrets, lib, pkgs, ... }:
let
  cfg = config.services.nextcloud;
  inherit (cfg) datadir occ;
in
{

 options = {
   services.nextcloud = {
    previewGenerator = lib.mkEnableOption "preview generator"; 


    # 
    # memories = lib.mkEnableOption "memories"; 

   };
          # occ memories:places-setup    # set up reverse geocoding, will force re-indexing
          # occ memories:index

  };
# 'preview_max_x' => 2048,
# 'preview_max_y' => 2048,

  # see https://memories.gallery/config/
# 'preview_max_memory' => 4096,
# 'preview_max_filesize_image' => 256,


 
 config = lib.mkIf cfg.previewGenerator  {
   # config.
   # services.nextcloud.package.packages.extraApps = with config.services.nextcloud.package.packages.apps; {
   #   # inherit news; # removed 'cos gives a wrong error
   #   # inherit memories;
   #   inherit previewgenerator;

   #  };

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
          serviceConfig.ExecStart = "${occ}/bin/nextcloud-occ preview:generate";
        };

 };
}
