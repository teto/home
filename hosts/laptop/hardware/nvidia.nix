{
  config,
  flakeInputs,
  lib,
  pkgs,
  ...
}:
{

  # this makes screen go black on boot :/
  modesetting.enable = true; # needs "modesetting" in videoDrivers ?

  open = false;
  # may need to select appropriate driver
  # choose between latest, beta, vulkan_beta, stable
  package = config.boot.kernelPackages.nvidiaPackages.latest;
  nvidiaSettings = true;

  # open is only ready for data center use 
  # open = true;
  powerManagement.enable = true;
  # Update for NVIDA GPU headless mode, i.e. nvidia-persistenced. It ensures all GPUs stay awake even during headless mode.
  # nvidiaPersistenced = true;
}
