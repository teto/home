{ config, lib, pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      # For Nixos version > 22.11
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    oci-containers = {
      backend = "podman";
      containers = {
        ubuntu = {
          autoStart = true;
          image = "ubuntu:latest";
          # extraOptions = ["--device=/dev/bus/usb/xxx/xxx" "--rm=false"];
          # entryPoint = "/bin/bash";
            volumes =  [
              "/home/teto/alot:/alot"
            ];
        };

        immich = {
          autoStart = true;
          image = "ubuntu:latest";
          # point at photos
          volumes =  [
              "/home/teto/immich-photos:/photos"
            ];
 

        };
      };
    };
  };
}
