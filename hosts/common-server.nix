{ config, pkgs, options, lib, ... } @ mainArgs:
{
  imports = [
    # /etc/nixos/hardware-configuration.nix
    ./config-all.nix
  ];

  environment.systemPackages = with pkgs; [
    host.dnsutils
  ];
}
