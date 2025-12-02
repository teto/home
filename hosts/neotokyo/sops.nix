{
  config,
  secretsFolder,
  dotfilesPath,
  ...
}:
{
  imports = [
    # ../../nixos/profiles/sops.nix
  ];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # todo use homeDir of users.teto ?
  sops.defaultSopsFile = "neotokyo-secrets.yaml";

  # to avoid the 'secrets.yaml' is not in the Nix store.
  sops.validateSopsFiles = false;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # sops.age.keyFile = "/home/teto/home/secrets/age.key";

  # %r gets replaced with a runtime directory, use %% to specify a '%'
  # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
  # DARWIN_USER_TEMP_DIR) on darwin.
  # path = "%r/test.txt";

}
