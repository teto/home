# On nixos-rebuild switch this will make the keys accessible via /run/secrets/example-key and /run/secrets/myservice/my_subdir/my_secret:
# $ cat /run/secrets/example-key
# example-value
# $ cat /run/secrets/myservice/my_subdir/my_secret
# password1
# https://github.com/Mic92/sops-nix
{ config, lib, pkgs, ... }:
{

  # sops.secrets.example-secret.mode = "0440";
  # # Either a user id or group name representation of the secret owner
  # # It is recommended to get the user name from `config.users.<?name>.name` to avoid misconfiguration
  # sops.secrets.example-secret.owner = config.users.nobody.name;
  # # Either the group id or group name representation of the secret group
  # # It is recommended to get the group name from `config.users.<?name>.group` to avoid misconfiguration
  # sops.secrets.example-secret.group = config.users.nobody.group;


  # This will automatically import SSH keys as age keys
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = false;

}
