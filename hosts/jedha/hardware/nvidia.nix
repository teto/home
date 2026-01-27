{
  config,
  ...
}:
{

  # this makes screen go black on boot :/
  modesetting.enable = true; # needs "modesetting" in videoDrivers ?

  # may need to select appropriate driver
  # choose between latest, beta, vulkan_beta, stable
  package = config.boot.kernelPackages.nvidiaPackages.stable;
  nvidiaSettings = true;

  # open is only ready for data center use
  # It is suggested to use the open source kernel modules on Turing or later GPUs (RTX series, GTX 16xx), and the closed source modules otherwise.
  open = false;
  powerManagement = {
    enable = false;
    # set to false 'cos of https://discourse.nixos.org/t/persistend-naming-of-igpu-in-sway-wrapper-script/66437/6
    # but seems weird
    finegrained = false;
  };
  # Update for NVIDA GPU headless mode, i.e. nvidia-persistenced. It ensures all GPUs stay awake even during headless mode.
  # nvidiaPersistenced = true;
}
