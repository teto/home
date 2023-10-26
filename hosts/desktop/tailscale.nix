{ config, lib, pkgs, ... }:
{
   # services.headscale.enable
   #     Whether to enable headscale, Open Source coordination server for Tailscale.
   services.tailscale = {

    enable = true;

    # authKeyFile = ;
   };
}

