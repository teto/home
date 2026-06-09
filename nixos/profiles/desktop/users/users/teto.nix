{
  config,
  lib,
  pkgs,
  ...
}:
{

  # lib.mkForce
  shell = pkgs.fish;

  extraGroups = [
    "audio" # for pulseaudio/pipewire
    "dialout" # to access serial devices like the conbee II
    "i2c" # to control brightness of the screen
    "kvm" # needed when using runAsRoot when building dockerImage
    "networkmanager" # not necessary for nixpos
    "rtkit" # for pipewire
    "seat" # necessary for lemurs
    "pipewire" # for pipewire
    "plugdev" # for udiskie
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
