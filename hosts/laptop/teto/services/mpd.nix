{ config, lib, pkgs, ... }:
{
  services.mpd = {
   musicDirectory = "~/Music";
  };
}
