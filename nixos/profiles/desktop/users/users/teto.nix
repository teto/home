{ config, lib, ... }:
{
  extraGroups =
    [
      "vboxusers" # to avoid Kernel driver not accessible
      "video" # to control brightness
      "wireshark"
      # "pgadmin" # pgadmin is such a mess
      "libvirtd" # for nixops
      "jupyter"
      "hass" # home-assistant
      "adbusers" # for android tools
    ]
    ++ lib.optional (config.services.kanata.enable) [

      "uinput" # required for kanata it seems
    ];

}
