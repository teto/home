{
  config
, ...
}:
{
  imports = [
    # ../../nixos/profiles/sops.nix
  ];
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # sops.age.keyFile = "/home/teto/home/secrets/age.key";

  # %r gets replaced with a runtime directory, use %% to specify a '%'
  # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
  # DARWIN_USER_TEMP_DIR) on darwin.
  # path = "%r/test.txt"; 

  # secrets.ssh_host_rsa = {
  #   mode = "400";
  #   owner = config.users.users.teto.name;
  #   group = config.users.users.teto.group;
  # };

}
