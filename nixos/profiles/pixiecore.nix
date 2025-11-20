{
  config,
  modulesPath,
  flakeSelf,
  lib,
  secretsFolder,
  pkgs,
  ...
}:
let
  netboot = pkgs.callPackage ./netboot.nix { };

  # build = 
   # sys = flakeSelf.nixosConfigurations.laptop.extendModules {
   #   modules = [
   #     (modulesPath + "/installer/netboot/netboot-minimal.nix")
   #    ];
   #  };
    build = sys.config.system.build;

  sys = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ];
        config = {
          services.openssh = {
            enable = true;
            openFirewall = true;

            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };

          users.users.root.openssh.authorizedKeys.keys = [
            # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
            "${secretsFolder}/ssh/id_rsa.pub"

          ];
        };
      })
    ];
  };

in
{
  services.pixiecore = {
    enable = true;
    debug = true;

    # extraArguments = ;
    # listen
    # cmdLine = ;

    dhcpNoBind = true; # Use existing DHCP server.

    quick = "ubuntu";
    openFirewall = true;

    # mode = "boot"; / "quick"

    # https://carlosvaz.com/posts/ipxe-booting-with-nixos/
    # kernel = "https://boot.netboot.xyz";
    # kernel = "${netboot}/bzImage";


    #
    # # requires 
    # # imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ];
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";

    # debug = true;

  };
}
