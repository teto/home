{
  config,
  pkgs,
  options,
  lib,
  ...
}@mainArgs:
{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    pkgs.btop
    host.dnsutils
    tmux
  ];
}
