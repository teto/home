{ config, pkgs, lib, secrets, 
# flakeInputs,
... }:
let
  secrets = import ../../../nixpkgs/secrets.nix;
in
{
  import = [
   # ../../../hm/profiles/zsh.nix
   # ../../profiles/bash.nix
  ];
}
