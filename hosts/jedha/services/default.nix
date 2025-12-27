{
  config,
  lib,
  pkgs,
  ...
}:
{
  # gnome = {
  #   gnome-keyring.enable = true;
  #   at-spi2-core.enable = true; # for keyring it seems
  # };

  # Enable CUPS to print documents.
  # https://nixos.wiki/wiki/Printing
  printing = {
    drivers = [
      pkgs.gutenprint
      pkgs.gutenprintBin
      # See https://discourse.nixos.org/t/install-cups-driver-for-brother-printer/7169
      pkgs.brlaser
    ];
  };

  # just locate
  locate.enable = true;
  dbus.packages = [
    # pkgs.deadd-notification-center # installed by systemd
    pkgs.gcr # for pinentry
    # pkgs.gnome.gdm
    # pkgs.gnome.gnome-control-center
  ];

  xserver = {
    videoDrivers = [
      # "nouveau"
      "nvidia"
    ];
  };

  # try giving stable ids to our GPUs
  udev.packages = [
    (pkgs.writeTextDir "etc/udev/rules.d/42-static-gpu-naming.rules"
      # lib.concatLines (
      #   ))
      # pci-0000:0e:00.0
      # ID_PATH=pci-0000:0e:00.0
      # ID_PATH_TAG=pci-0000_0e_00_0
      ''
        KERNEL=="card*", SUBSYSTEM=="drm", ATTRS{vendor}=="0x10de", ATTRS{device}=="0x13c0", SYMLINK+="dri/by-name/igpu"
        KERNEL=="card*", SUBSYSTEM=="drm", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x2504", SYMLINK+="dri/by-name/egpu"
      ''
    )
  ];

}
