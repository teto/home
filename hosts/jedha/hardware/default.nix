{

  sane.enable = true;
  # nvidia-container-toolkit.enable = true;

  # for moonloader keyboard
  keyboard.zsa.enable = true;
  bluetooth = {
    enable = true;
    powerOnBoot = false;
    # hsphfpd.enable = false; # conflicts with pipewire
      # written to /etc/bluetooth/main.conf
      settings = {

        General = {
          Name = "jedha";

          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;

          # to work with a2dp profile (seems outdated)
          # unknown key
          # Enable = "Source,Sink,Media,Socket";
        };
        Policy = {
          # Enable all controllers when they are found. This includes
          # adapters present on start as well as adapters that are plugged
          # in later on. Defaults to 'true'.
          AutoEnable = true;
        };
      };
  };
}
