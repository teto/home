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
    host.dnsutils
    tmux
  ];
}
