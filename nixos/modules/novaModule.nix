{
  flakeInputs,
  pkgs,
  secrets,
  withSecrets,
  ...
}:
{
  imports = [
    # ./nixos/profiles/nova/rstudio-server.nix

    ../profiles/nova.nix
    flakeInputs.nova-doctor.nixosModules.gnome
  ];

  # # devrait deja etre ok ?
  # home-manager.extraSpecialArgs = {
  #   inherit secrets withSecrets;
  #   # withSecrets = true;
  #   # flakeInputs = self.inputs;
  # };

  environment.systemPackages = [
    pkgs.doctor_manage_collections

  ];

  home-manager.users.teto = {
    imports = [

      # TODO move it here
      ../../hm/profiles/nova/ssh-config.nix

      flakeInputs.nova-doctor.homeModules.user
      flakeInputs.nova-doctor.homeModules.sse
      flakeInputs.nova-doctor.homeModules.vpn
    ];
  };
}
