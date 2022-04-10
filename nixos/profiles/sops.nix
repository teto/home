# On nixos-rebuild switch this will make the keys accessible via /run/secrets/example-key and /run/secrets/myservice/my_subdir/my_secret:
# $ cat /run/secrets/example-key
# example-value
# $ cat /run/secrets/myservice/my_subdir/my_secret
# password1
# https://github.com/Mic92/sops-nix
{ config, lib, pkgs,  ... }:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  sops.defaultSopsFile = ../../secrets/example.yaml;

  # This will automatically import SSH keys as age keys
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/home/teto/.config/sops/age/keys.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = false;

  # By default secrets are owned by root:root. Furthermore the parent directory /run/secrets.d is only owned by root and the keys group has read access to it:
  # This is the actual specification of the secrets.
  sops.secrets."github_token" = {
	mode = "400";
	owner = config.users.users.teto.name;
	group = config.users.users.teto.group;

  };

  # sops.secrets."nextcloud" = {
	# mode = "400";
	# owner = config.users.users.teto.name;
	# group = config.users.users.teto.group;
  # };
  # sops.secrets."myservice/my_subdir/my_secret" = {};

  # sops.secrets.example-secret.mode = "0440";
  # # Either a user id or group name representation of the secret owner
  # # It is recommended to get the user name from `config.users.<?name>.name` to avoid misconfiguration
  # sops.secrets.example-secret.owner = config.users.nobody.name;
  # # Either the group id or group name representation of the secret group
  # # It is recommended to get the group name from `config.users.<?name>.group` to avoid misconfiguration
  # sops.secrets.example-secret.group = config.users.nobody.group;

}
