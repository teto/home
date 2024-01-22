{ config, lib, pkgs, ... }:
{
  services.xserver = {
    videoDrivers = [
      "nvidia"
     ];
   };

  environment.systemPackages = [
    # pkgs.linuxPackages.nvidia_x11.bin # to get nvidia-smi EVEN when nvidia is not used as a video driver
    pkgs.nvidia-podman
    pkgs.nvidia-system-monitor-qt  # executable is called qnvsm
    pkgs.nvitop
  ];

}
