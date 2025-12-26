{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.ssh.enable = true;

  programs.ssh.enableDefaultConfig = false;

}
