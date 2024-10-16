{
  config,
  flakeSelf,
  flakeInputs,
  secrets,
  modulesPath,
  pkgs,
  lib,
  ...
}:
let
  # TODO add a justfile to run the basic steps
  banner = "You can start the nextcloud-add-user.service unit if teto user doesnt exist yet";
in
{
  networking = {
    hostName = "neotokyo";
    firewall = {
      enable = true;
    };
  };

  system.stateVersion = "23.11";

  # imported from gandhi ?
  boot.initrd.kernelModules = [
    "xen-blkfront"
    "xen-tpmfront"
    "xen-kbdfront"
    "xen-fbfront"
    "xen-netfront"
    "xen-pcifront"
    "xen-scsifront"
  ];
  # This is to get a prompt via the "openstack console url show" command
  systemd.services."getty@tty1" = {
    enable = lib.mkForce true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Restart = "always";
  };

  programs.bash.interactiveShellInit = ''
    cat "${pkgs.writeText "welcome-message" banner}";
  '';

  imports = [
    # for gandi
    "${modulesPath}/virtualisation/openstack-config.nix"
    flakeSelf.nixosModules.teto-nogui

    # ./hardware.nix
    ./services/openssh.nix
    ./sops.nix

    # to get the first iteration going on
    ./services/nextcloud.nix
    ./services/nginx.nix
    ./services/immich.nix

    # ./gitolite.nix
    # ../../nixos/modules/hercules-ci-agents.nix

    ../../nixos/profiles/ntp.nix
    ../../nixos/profiles/nix-daemon.nix
    ../../nixos/profiles/neovim.nix
    # ../../nixos/profiles/docker-daemon.nix
    ../../nixos/profiles/server.nix

    # ./blog.nix

    # just to help someone on irc
    # <nixpkgs/nixos/modules/profiles/hardened.nix>

  ];

  # virtualisation.docker.enable = true;

  users.users.teto = {
    extraGroups = [
      "nextcloud" # to be able to list files
    ];
  };

  home-manager.users = { 
    root = {
      imports = [
        # ./users/root.nix
        ../../hm/profiles/neovim.nix
        ../desktop/root/programs/ssh.nix
      ];

    # home.stateVersion = "23.11";
    };
    teto = {
    # TODO it should load the whole folder
    imports = [
      flakeSelf.homeModules.teto-nogui

      ./teto/default.nix
      ../../hm/profiles/neovim.nix

      # custom modules
      # ./home.nix
      # breaks build: doesnt like the "activation-script"
    ];
    };
  };

  boot.loader = {
    #    systemd-boot.enable = true;
    # efi.canTouchEfiVariables = true; # allows to run $ efi...
    # systemd-boot.editor = true; # allow to edit command line
    # because it's so hard to timely open VNC, we increase timetout
    timeout = lib.mkForce 15;
    # just to generate the entry used by ubuntu's grub
    grub = {
      enable = true;
      useOSProber = true;
      # install to none, we just need the generated config
      # for ubuntu grub to discover
      device = lib.mkForce "/dev/xvda";
    };
  };

  # security.sudo.wheelNeedsPassword = true;

  # environment.systemPackages = with pkgs; [ ];

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
