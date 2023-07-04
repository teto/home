{ config, lib, pkgs, ... }:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = ./secrets.yaml;


  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";


  sops.secrets."gitlab/registrationToken" = {
    mode = "0440";
    # TODO only readable by gitlab
    owner = config.users.users.teto.name;
    group = config.users.users.nobody.group;
  };

}
