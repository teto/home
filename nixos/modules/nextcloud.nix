{ config, secrets, lib, pkgs, ... }:
let
  cfg = config.services.nextcloud;
in
{

  options.services.nextcloud = {
   previewgenerator = lib.mkEnableOption "preview generator"; 
  };
# 'preview_max_x' => 2048,
# 'preview_max_y' => 2048,

  # see https://memories.gallery/config/
# 'preview_max_memory' => 4096,
# 'preview_max_filesize_image' => 256,

}
