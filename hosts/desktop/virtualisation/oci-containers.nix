{
      backend = "podman";
      containers = {
        # doctor = {
        #  #  executable file `sleep unlimited` not found in $PATH: No such file or directory
        #  # cmd = ["sleep unlimited" ];
        #  # entrypoint = '
        #   autoStart = true;
        #   # TODO load the one from 
        #   image = "ubuntu:latest";
        #   # extraOptions = ["--device=/dev/bus/usb/xxx/xxx" "--rm=false"];
        #   # entryPoint = "/bin/bash";
        #     volumes =  [
        #       "/home/teto/nova/doctor:/doctor"
        #     ];
        #     # extraOptions = [ "--network=host" ]
        # };
        # ubuntu = {
        #   autoStart = true;
        #   image = "ubuntu:latest";
        #   # extraOptions = ["--device=/dev/bus/usb/xxx/xxx" "--rm=false"];
        #   # entryPoint = "/bin/bash";
        #     volumes =  [
        #       "/home/teto/alot:/alot"
        #     ];
        #     # extraOptions = [ "--network=host" ]
        # };

        # immich = {
        #   autoStart = true;
        #   image = "ubuntu:latest";
        #   # point at photos
        #   volumes =  [
        #       "/home/teto/immich-photos:/photos"
        #     ];

        # };
      };
    }
