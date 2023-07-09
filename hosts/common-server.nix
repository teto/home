{ config, pkgs, options, lib, ... } @ mainArgs:
{
  imports = [
    ./config-all.nix
  ];

  environment.systemPackages = with pkgs; [
    host.dnsutils
	tmux
  ];
}
