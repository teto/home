{
  config,
  lib,
  dotfilesPath,
  flakeInputs,
  pkgs,
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
    pkgs.tailscale-systray
    pkgs.trayscale
  ];


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
    users =
    {
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
