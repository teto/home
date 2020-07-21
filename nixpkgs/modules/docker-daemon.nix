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

  # services.dockerRegistry = {

  #   enable = false;
  #   enableGarbageCollect = true;
  #   # garbageCollectDates
  #   port = 5000;  # 5000 is the default
  #   listen = "localhost";
  #   # storagePath
  # };

  environment.systemPackages = with pkgs; [
    docker-credential-helpers
  ];
}
