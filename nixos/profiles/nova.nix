{
  lib,
  flakeSelf,
  pkgs,
  novaUserProfile,
  ...
}:
{
  imports = [
    flakeSelf.inputs.nova-doctor.nixosModules.antivirus
    flakeSelf.inputs.nova-doctor.nixosModules.collections
    flakeSelf.inputs.nova-doctor.nixosModules.vpn
    flakeSelf.inputs.nova-doctor.nixosModules.nix-daemon
    flakeSelf.inputs.nova-doctor.nixosModules.virt-manager

    # we need both because nova consumes quite a bit of CPU
    flakeSelf.inputs.nova-doctor.nixosModules.gnome
    flakeSelf.nixosProfiles.gnome
  ];

  environment.systemPackages = [
    pkgs.doctor_upgrade_nixos
    pkgs.dbeaver-bin
  ];

  # home-manager = {
  #   users = {
  #     root = {
  #       imports = [
  #         flakeSelf.inputs.nova-doctor.homeModules.root
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

    # novaUserProfile.userName
    teto = {
      imports = [
        # TODO move it here
        ../../hm/profiles/nova.nix

        flakeSelf.inputs.nova-doctor.homeModules.user
        flakeSelf.inputs.nova-doctor.homeModules.sse
        flakeSelf.inputs.nova-doctor.homeModules.vpn
      ];
    };
  };

  # for sharedssh access
  # services.gvfs.enable = true;


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
  '';
}
