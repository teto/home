# disko main config
{

  # shall we add a swap partition later ?
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # in general that's the one
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
        # content = {
        #   type = "gpt";
        #   partitions = {
        #     ESP = {
        #       size = "512M";
        #       type = "EF00";
        #       content = {
        #         type = "filesystem";
        #         format = "vfat";
        #         mountpoint = "/boot";
        #         mountOptions = [ "umask=0077" ];
        #       };
        #     };
        #     # todo rename
        #     root = {
        #       # end = "-32G";
        #       size = "100%";
        #       content = {
        #         type = "filesystem";
        #         format = "ext4";
        #         mountpoint = "/";
        #       };
        #     };
        #
        #     # availableKernelModules
        #
        #     # encryptedSwap = {
        #     #   size = "10M";
        #     #   content = {
        #     #     type = "swap";
        #     #     randomEncryption = true;
        #     #     priority = 100; # prefer to encrypt as long as we have space for it
        #     #   };
        #     # };
        #     # plainSwap = {
        #     #   size = "100%";
        #     #   content = {
        #     #     type = "swap";
        #     #     discardPolicy = "both";
        #     #     resumeDevice = true; # resume from hiberation from this device
        #     #   };
        #     # };
        #   };
        # };
      };
    };
  };
}
