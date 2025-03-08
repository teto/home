# TODO this should be fetched from the runners themselves !
{
  config,
  pkgs,
  lib,
  secrets,
  # , flakeSelf.inputs
  ...
}:
let
  # secrets = import ../../../nixpkgs/secrets.nix;
  # sshLib = import ../../../nixpkgs/lib/ssh.nix { inherit secrets flakeSelf.inputs; };

in
{
  # imports = [
  #  ../../../hm/profiles/nova/ssh-config.nix
  # ];

  # programs.ssh.enable = true;
}
