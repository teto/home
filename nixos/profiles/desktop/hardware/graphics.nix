{ pkgs, ... }:
{
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [
    libvdpau-va-gl
    libva
    # trying to fix `WLR_RENDERER=vulkan sway`
    vulkan-validation-layers # broken
  ];

}
