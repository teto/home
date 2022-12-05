{ config, pkgs, options, lib, ... } @ mainArgs:
{
  imports = [
    # todo renommer en workstation
    # ./hardware-dell.nix
    # /etc/nixos/hardware-configuration.nix
    ./config-all.nix
  ];

  environment.systemPackages = with pkgs; [
    host.dnsutils
  ];
}
