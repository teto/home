{
  imports = [
    ({ networking.hostId = "815eb178"; })
    ({
      networking.hostName = "teto";
      networking.dhcpcd.enable = false;
      networking.defaultGateway = {
        address = "139.178.88.226";
        interface = "bond0";
      };
      networking.defaultGateway6 = {
        address = "2604:1380:1000:dc00::2";
        interface = "bond0";
      };
      networking.nameservers = [
        "147.75.207.207"
        "147.75.207.208"
      ];

      networking.bonds.bond0 = {
        driverOptions = {
          mode = "802.3ad";
          xmit_hash_policy = "layer3+4";
          lacp_rate = "fast";
          downdelay = "200";
          miimon = "100";
          updelay = "200";
        };

        interfaces = [
          "enp5s0f0"
          "enp5s0f1"
        ];
      };

      networking.interfaces.bond0 = {
        useDHCP = false;
        macAddress = "50:6b:4b:b7:11:aa";

        ipv4 = {
          routes = [
            {
              address = "10.0.0.0";
              prefixLength = 8;
              via = "10.88.106.2";
            }
          ];
          addresses = [
            {
              address = "139.178.88.227";
              prefixLength = 31;
            }
            {
              address = "10.88.106.3";
              prefixLength = 31;
            }
          ];
        };

        ipv6 = {
          addresses = [
            {
              address = "2604:1380:1000:dc00::3";
              prefixLength = 127;
            }
          ];
        };
      };
    })
    ({
      imports = [
        ({
          boot.kernelModules = [
            "dm_multipath"
            "dm_round_robin"
            "ipmi_watchdog"
          ];
          services.openssh.enable = true;
        })
        ({
          boot.initrd.availableKernelModules = [
            "ahci"
            "mpt3sas"
            "sd_mod"
            "xhci_pci"
          ];
          boot.kernelModules = [ "kvm-amd" ];
          boot.kernelParams = [ "console=ttyS1,115200n8" ];
          boot.extraModulePackages = [ ];
        })
        (
          { lib, ... }:
          {
            boot = {
              loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
              };
            };
            # nix.settings.max-jobs = lib.mkDefault 48;
          }
        )
      ];
    })
    ({
      swapDevices = [ ];

      fileSystems = {

        "/boot" = {
          device = "/dev/disk/by-id/ata-SSDSCKJB120G7R_PHDW808400TU150A-part1";
          fsType = "vfat";

        };

        "/" = {
          device = "npool/root";
          fsType = "zfs";
          options = [ "defaults" ];
        };

        "/nix" = {
          device = "npool/nix";
          fsType = "zfs";
          options = [ "defaults" ];
        };

        "/home" = {
          device = "npool/home";
          fsType = "zfs";
          options = [ "defaults" ];
        };

      };

      boot.loader.efi.efiSysMountPoint = "/boot";
    })
  ];
}
