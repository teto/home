{
  config,
  lib,
  pkgs,
  ...
}:
{
  # This will no longer be necessary when
  # https://github.com/NixOS/nixpkgs/pull/326369 hits stable
  # 'true' makes screen go black on boot :/
  modesetting.enable = true; # needs "modesetting" in videoDrivers ?

  # open is only ready for data center use
  open = true;

  # may need to select appropriate driver
  # choose between latest, beta, vulkan_beta, stable
  package = config.boot.kernelPackages.nvidiaPackages.latest;
  nvidiaSettings = true;
  # Power management is nearly always required to get nvidia GPUs to
  # behave on suspend, due to firmware bugs.
  powerManagement.enable = false;

  # Update for NVIDA GPU headless mode, i.e. nvidia-persistenced. It ensures all GPUs stay awake even during headless mode.
  # nvidiaPersistenced = true;
}
