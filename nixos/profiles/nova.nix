{
  config,
  lib,
  dotfilesPath,
  flakeInputs,
  pkgs,
  secrets,
  ...
}:
{

  # for sharedssh access
  # services.gvfs.enable = true;

  imports = [ ];
  services.tailscale = {

    enable = true;

    # necessary for headscale
    useRoutingFeatures = "client";
  };

  environment.systemPackages = [
    pkgs.dbeaver-bin
    # pkgs.tailscale-systray
    # pkgs.trayscale
  ];

  # userName = secrets.accounts.mail.nova.email;
  # Expected by
  environment.etc."nixos/nova-nixos/config.json".text = builtins.toJSON {
    README = "this file is a dummy one, used to include most dependencies in the liveboot";
    displayname = "Matt C";

    email = secrets.nova.accounts.email;
    # password = "$6$rounds=656000$kfC6x6MDyR33Wgdo$m0IcbB1psI.yacdCwZRUvrzSeB6a5h2wnaS2VRtYV0WOPPSdWnG7vO3fGVcn9rmTGN.Ic0rWkDarHGFSkZFXM1";
    pc = "nova";
    team = "sse";
    configuration = "autoDetect";
    keyboard_layout = "qwerty";
    swap_size = 0;
    cpu_types = [ ];
    laptop = false;
    uefi = false;
    is_vm = false;
    main_disk = "/dev/dummy";
    other_disks = [ ];
    install_branch = "dev";
    has_sudo = false;
    collections = [ ];
  };

  # let
  # hmRootModule = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
  #  src = ./root;
  #  inputs = args // {
  #    inputs = flakeInputs;
  #  };
  #  transformer =  [
  #    flakeInputs.haumea.lib.transformers.liftDefault

  #  #  (x: hoistAttrs x )
  #    # (x: )
  #  ];
  #   # flakeInputs.haumea.lib.transformers.liftDefault;
  # };
  # in 
  home-manager = {
    users = {
      root = {
        imports = [
          flakeInputs.nova-doctor.homeModules.root
          # ./root/programs/ssh.nix
          # ../../hm/profiles/nova/ssh-config.nix
        ];
        programs.zsh.enable = true;
        # sops.defaultSopsFile = ../secrets.yaml;
        #
        # # This is using an age key that is expected to already be in the filesystem
        # # sops.age.keyFile = "secrets/age.key";
        # sops.age.keyFile = "${dotfilesPath}/secrets/age.key";
      };
    };
  };

  # to test locally
  # services.gitlab-runner.enable = true;

  # nix = {
  # };
  #
  # programs.fuse.userAllowOther = false;
}
