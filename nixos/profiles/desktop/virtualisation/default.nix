{
    oci-containers = {
      backend = "podman";
      containers = {
        # ubuntu = {
        #   autoStart = true;
        #   image = "ubuntu:latest";
        #   # extraOptions = ["--device=/dev/bus/usb/xxx/xxx" "--rm=false"];
        #   # entryPoint = "/bin/bash";
        #     volumes =  [
        #     ];
        #     # extraOptions = [ "--network=host" ]
        # };

      };
    };
}
