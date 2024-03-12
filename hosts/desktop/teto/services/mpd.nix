{ config, lib, pkgs, ... }:
{
  services.mpd = {
   musicDirectory = "/mnt/ntfs/Musique";
  };
}
