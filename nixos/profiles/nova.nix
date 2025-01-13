{
  config,
  lib,
  dotfilesPath,
  flakeSelf,
  pkgs
, secrets
, novaUserProfile
, ...
}:
let 
  flakeInputs = flakeSelf.inputs;
in
{
  imports = [
    # ./nixos/profiles/nova/rstudio-server.nix

    # ../profiles/nova.nix
    flakeInputs.nova-doctor.nixosModules.antivirus
    flakeInputs.nova-doctor.nixosModules.collections
    flakeInputs.nova-doctor.nixosModules.vpn
    flakeInputs.nova-doctor.nixosModules.nix-daemon

    # we need both because nova consumes quite a bit of CPU
    flakeInputs.nova-doctor.nixosModules.gnome
    flakeSelf.nixosModules.gnome
  ];

  # # devrait deja etre ok ?
  # home-manager.extraSpecialArgs = {
  #   inherit secrets withSecrets;
  #   # withSecrets = true;
  #   # flakeInputs = self.inputs;
  # };

  environment.systemPackages = [
    pkgs.doctor_upgrade_nixos
    pkgs.dbeaver-bin
    # pkgs.tailscale-systray
    # pkgs.trayscale
    # pkgs.doctor_manage_collections
  ];

  # home-manager = {
  #   users = {
  #     root = {
  #       imports = [
  #         flakeInputs.nova-doctor.homeModules.root
  #       ];
  #       programs.zsh.enable = true;
  #       # sops.defaultSopsFile = ../secrets.yaml;
  #       #
  #       # # This is using an age key that is expected to already be in the filesystem
  #       # # sops.age.keyFile = "secrets/age.key";
  #       # sops.age.keyFile = "${dotfilesPath}/secrets/age.key";
  #     };
  #   };
  # };

  home-manager.users = {
    root = {
      imports = [
        flakeSelf.inputs.nova-doctor.homeModules.root
        ../../hm/profiles/nova/ssh-config.nix
      ];
    };

    teto = {
      imports = [
        # TODO move it here
        ../../hm/profiles/nova/ssh-config.nix

        flakeInputs.nova-doctor.homeModules.user
        flakeInputs.nova-doctor.homeModules.sse
        flakeInputs.nova-doctor.homeModules.vpn
      ];
    };
  };

  # for sharedssh access
  # services.gvfs.enable = true;

  # userName = secrets.accounts.mail.nova.email;
  # Expected by

  # builtins.toJSON
  # lib.generators.toPretty {}
  environment.etc."nixos/nova-nixos/config.json".text = builtins.toJSON novaUserProfile;
  # programs.fuse.userAllowOther = false;

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
