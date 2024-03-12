{ config, lib, pkgs, ... }:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  defaultSopsFile = ../secrets.yaml;


  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "secrets/age.key";
  age.keyFile = "/home/teto/home/secrets/age.key";

}
