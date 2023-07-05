{ config, lib, pkgs, ... }:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = ../desktop/secrets.yaml;

  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
}
