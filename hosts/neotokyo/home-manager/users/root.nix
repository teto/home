{
  flakeSelf,
  pkgs,
  lib,
  secrets,
  ...
}:
let
  tetoEmail = secrets.users.teto.email;
in
{

  home.stateVersion = "26.05";

  programs.ssh.enable = true;

  programs.ssh.enableDefaultConfig = false;

  imports = [
    flakeSelf.homeModules.nixpkgs-monitor
  ];

}
