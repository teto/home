{
  flakeInputs,
  pkgs,
  lib,
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

  # TODO  move to doctor
  # https://github.com/containers/image/blob/main/docs/containers-registries.conf.5.md
  # look into credential-helpers
  #
  # public.ecr.aws
  environment.etc."containers/registries.conf".text = lib.mkForce ''
    # Note that order matters here. quay.io is the redhat repo
    unqualified-search-registries = [  "registry.novadiscovery.net", "docker.io", "quay.io" ]

    [[registry]]
    # In Nov. 2020, Docker rate-limits image pulling.  To avoid hitting these
    # limits while testing, always use the google mirror for qualified and
    # unqualified `docker.io` images.
    # Ref: https://cloud.google.com/container-registry/docs/pulling-cached-images
    prefix="docker.io"
    location="mirror.gcr.io"

    [[registry]]
    prefix = "nova"
    location = "registry.novadiscovery.net"
    insecure = false

    # Alias used in tests. Must contain registry AND repository
    [aliases]
      simwork = "registry.novadiscovery.net/jinko/jinko/core-webservice"
      habu = "registry.novadiscovery.net/jinko/dorayaki/habu"
      dango = "registry.novadiscovery.net/jinko/dorayaki/dango"
      # "podman-desktop-test123"="florent.fr/will/like"
  '';
}
