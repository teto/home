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


  environment.systemPackages = with pkgs; [
    docker-credential-helpers
  ];
}
