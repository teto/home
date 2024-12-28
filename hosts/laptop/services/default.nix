{ pkgs, ...}:
{
  # environment.
  # service to update bios etc
  # managed to get this problem https://github.com/NixOS/nixpkgs/issues/47640
  fwupd.enable = true;
  gvfs.enable = true;
  gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true; # for keyring it seems
    };

    # central regulatory domain agent (CRDA) to allow exchange between kernel and userspace
    # to prevent the "failed to load regulatory.db" ?
    # see https://wireless.wiki.kernel.org/en/developers/regulatory
    udev.packages = [ ];

    # just locate
    locate.enable = true;
    # dbus.packages = [ ];
  }
