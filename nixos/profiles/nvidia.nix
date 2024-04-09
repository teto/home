{ config, lib, pkgs, ... }:
{
  # services.xserver = {
  #   videoDrivers = [
  #     "nvidia"
  #    ];
  #  };

  hardware.nvidia-container-toolkit.enable = true;
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true; 
  virtualisation.docker.enableNvidia = false;

  environment.systemPackages = [
    pkgs.nvidia-system-monitor-qt  # executable is called qnvsm
    pkgs.nvitop
    pkgs.vulkan-tools # for vkcude for instance
    # pkgs.vkmark # vkmark to test
  ];

}
