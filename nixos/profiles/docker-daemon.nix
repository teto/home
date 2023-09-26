{ pkgs, lib, config, ... }:
{
  # docker pull mattator/dce-dockerfiles
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    # listenOptions = [
    # "0.0.0.0:80"
    # ];
    # logDriver = 
    # liveRestore
  };

  services.dockerRegistry = {

    enable = false;
    # enableGarbageCollect = true;
    # garbageCollectDates
    port = 6000; # 5000 is the default but already used by docker
    # listen = "localhost";
    # storagePath
  };

  environment.systemPackages = with pkgs; [
    # if docker finds the binary, it will try to use it ! 
    # docker-credential-helpers
  ];
}
