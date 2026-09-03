{

  hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      # package =
      # written to /etc/bluetooth/main.conf
      settings = {

        General = {
          Name = "toto";
          # Restricts all controllers to the specified transport. Default value
          # is "dual", i.e. both BR/EDR and LE enabled (when supported by the HW).
          # Possible values: "dual", "bredr", "le"
          #ControllerMode = dual
          # https://unix.stackexchange.com/questions/736933/what-is-the-bluetooth-controllermode-in-etc-bluetooth-main-conf-what-is-bredr
          ControllerMode = "bredr";

          # Shows battery charge of connected devices on supported
          # Bluetooth adapters. Defaults to 'false'.
          Experimental = true;
          KernelExperimental = true;

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
    }

}
