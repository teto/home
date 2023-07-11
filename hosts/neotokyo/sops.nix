{ config, lib, pkgs, ... }:
{
 imports = [
      ../../nixos/profiles/sops.nix
 ];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # This is using an age key that is expected to already be in the filesystem
  # sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
  sops.secrets."nextcloud/tetoPassword" = {
    mode = "0440";
    # TODO only readable by gitlab
    owner = config.users.users.nextcloud.name;
    group = config.users.users.nextcloud.group;
  };


}
