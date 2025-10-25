{ pkgs, ... }:
{
  # config from https://discourse.nixos.org/t/nvidia-users-testers-requested-sway-on-nvidia-steam-on-wayland/15264/32
  extraPackages = with pkgs; [ vaapiVdpau ];

}
