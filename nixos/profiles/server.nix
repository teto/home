{ config, pkgs, options, lib, ... } @ mainArgs:
{
  imports = [
    ../../hosts/config-all.nix
  ];

  environment.systemPackages = with pkgs; [
    host.dnsutils
	tmux
  ];
}
