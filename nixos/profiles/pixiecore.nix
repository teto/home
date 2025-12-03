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
  build = sys.config.system.build;

  # build =
  # sys = flakeSelf.nixosConfigurations.laptop.extendModules {
  #   modules = [
  #     (modulesPath + "/installer/netboot/netboot-minimal.nix")
  #     {
  #       boot.supportedFilesystems = {
  #          zfs = lib.mkForce false;
  #       };
  #     }
  #    ];
  #  };

  # TODO enable mdns / avahi and give him host name "bootstrap.local"
  sys = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      (
        {
          config,
          pkgs,
          lib,
          modulesPath,
          ...
        }:
        {
          imports = [
            (modulesPath + "/installer/netboot/netboot-minimal.nix")
            ../accounts/teto/teto.nix
          ];

          config = {
            nix = {
              settings = {
                extra-experimental-features = "auto-allocate-uids nix-command flakes cgroups";

                substituters = [
                  # "https://nix-community.cachix.org"
                  "https://cache.nixos-cuda.org"
                ];

                trusted-public-keys = [
                  "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
                ];
              };
            };

            boot.supportedFilesystems = {
              # had compilation issues with it
              zfs = lib.mkForce false;
            };

            # to automatically run disko ?
            # environment.etc."bashrc.local".text = ''
            #   '';

            services.openssh = {
              enable = true;
              openFirewall = true;

              settings = {
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
              };
            };

            security.sudo.wheelNeedsPassword = false;

            environment.systemPackages = [
              # TODO provide a better neovim / hx
              pkgs.neovim
              flakeSelf.inputs.nixos-wizard.packages."x86_64-linux".default
            ];

            # this is problematic because it sets tteto as both a system and a normal user
            # users.users.teto.openssh.authorizedKeys.keys = [
            #   (builtins.readFile ../../perso/keys/id_rsa.pub)
            # ];

            users.users.root.openssh.authorizedKeys.keys = [
              (builtins.readFile ../../perso/keys/id_rsa.pub)

              # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
              # "${secretsFolder}/ssh/id_rsa.pub"
            ];

            system.stateVersion = "25.11";
          };
        }
      )
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
