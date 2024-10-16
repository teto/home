{
  flakeInputs,
  secrets,
  withSecrets,
  ...
}:
{
  imports = [
    # ./nixos/profiles/nova/rstudio-server.nix

    flakeInputs.nova-doctor.nixosModules.gnome
  ];

  # # devrait deja etre ok ?
  # home-manager.extraSpecialArgs = {
  #   inherit secrets withSecrets;
  #   # withSecrets = true;
  #   # flakeInputs = self.inputs;
  # };

  home-manager.users.teto = {
    imports = [
      # ../../hosts/desktop/teto/programs/ssh.nix
      # ../../hosts/desktop/teto/programs/bash.nix

      ../../hm/profiles/nova/ssh-config.nix

      flakeInputs.nova-doctor.homeModules.user
      flakeInputs.nova-doctor.homeModules.sse
      # flakeInputs.nova-doctor.homeModules.vpn
    ];
  };
}
