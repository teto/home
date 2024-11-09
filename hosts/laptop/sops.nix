{
  secretsFolder,
  dotfilesPath,

  ...
}:
{

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = "${secretsFolder}/desktop-secrets.yaml";
  # to avoid the 'secrets.yaml' is not in the Nix store.
  sops.validateSopsFiles = false;

  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "${secretsFolder}/age.key";
}
