{ pkgs, ...}:
{
    # enableAllFirmware =true;
    enableRedistributableFirmware = true;
    sane.enable = true;
    # High quality BT calls
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      # hsphfpd.enable = false; # conflicts with pipewire
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    pulseaudio = {
      enable = false;
      systemWide = false;

      # extraClientConf =
      # only this one has bluetooth
      package = pkgs.pulseaudioFull;
    };
  }
