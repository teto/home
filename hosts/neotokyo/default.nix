#
# create a service to monitor new blog
{
  config,
  flakeSelf,
  pkgs,
  lib,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  autoloadedProfiles =
    let
      filteredSrc = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          ./home-manager
          ./users/default.nix
          ./ca.json
          ./sops.nix
          ./nix.nix
          ./intermediate_ca.crt
          ./systemd.nix
          ./networking.nix
          ./security.nix
          ./programs/msmtp.nix
          ./services/openssh.nix
          ./services/gitolite.nix
          ./services/llama-cpp.nix
          ./services/harmonia.nix
          ./services/jellyfin.nix
          ./services/restic.nix
          ./services/immich.nix
          ./services/step-ca.nix
          # ./services/buildbot-nix.nix
          ./services/nixbot.nix
          ./services/transmission.nix
          ./services/headscale.nix
          # ./services/vaultwarden.nix
          # ./services/linkwarden.nix
        ];
      };
    in
    { pkgs, ... }@args:
    haumea.lib.load {
      src = filteredSrc;

      inputs = args // {
        osConfig = config;
        # kinda hack
        rootCaPath = ../../nixos/profiles/desktop/root_ca.crt;
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{
  # does it make sense to harden it with ?
  # fileSystems."/".options = [ "noexec" ];

  # bumping to 25.11 broke nextcloyud
  system.stateVersion = "25.05";

  boot.kernel.sysctl = {
    "fs.protected_fifos" = 2;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = false;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = false;
    "kernel.unprivileged_bpf_disabled" = true;

    # for wireguard
    "net.ipv4.conf.all.forwarding" = true;
  };

  # some hardening
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
  ];

  tetos.wireguard = {
    enable = true;
    id = 1;
    privateKeyFile = config.sops.secrets.wg-private-key.path;
    publicKey = "1uhd6iscyFt68twrVz+y4zvws5PzhpIuY4rrr4N/Ymk=";

  };

  # services.dbus.implementation = "dbus";

  imports = [

    ./ovh.nix

    autoloadedProfiles
    ./disko-config.nix

    flakeSelf.nixosProfiles.systemd-on-failure-service

    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.nixosModules.teto-nogui
    flakeSelf.nixosModules.default-hm
    flakeSelf.nixosModules.wireguard

    flakeSelf.nixosProfiles.wireguard
    flakeSelf.nixosProfiles.server
    flakeSelf.nixosProfiles.nix-daemon

    ./hardware.nix

    # move to autoloaded
    ./services/nextcloud.nix
    # ./services/postgresqlBackup.nix
    ./services/nginx.nix
    # ./services/restic.nix

    # testing
    # ./services/hedgedoc.nix

    # ../../nixos/modules/hercules-ci-agents.nix

    flakeSelf.nixosProfiles.server

    # TODO remove once nixbot succeeds
    # flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-master
    # flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-worker
    flakeSelf.inputs.nixbot.nixosModules.nixbot
  ];

  # home-manager.users = {
  #
  #   teto = {
  #     # TODO it should load the whole folder
  #     imports = [
  #       # ./home-manager/users/teto/default.nix
  #       # flakeSelf.homeProfiles.neovim
  #       # flakeSelf.homeProfiles.yazi
  #     ];
  #   };
  # };

  boot.loader = {
    #    systemd-boot.enable = true;
    # efi.canTouchEfiVariables = true; # allows to run $ efi...
    # systemd-boot.editor = true; # allow to edit command line
    # because it's so hard to timely open VNC, we increase timetout
    timeout = lib.mkForce 15;
    # just to generate the entry used by ubuntu's grub
    # grub = {
    #   enable = true;
    #   useOSProber = false;
    #   # install to none, we just need the generated config
    #   # for ubuntu grub to discover
    #   # device = lib.mkForce "/dev/xvda";
    # };
  };

  documentation.enable = false;

  # lib.mkForce to remove the default ones
  environment.systemPackages = lib.mkForce [
    # flakeSelf.inputs.transgression-tui.packages.${pkgs.stdenv.hostPlatform.system}.transgression-tui
    pkgs.tremc
    pkgs.restic # testing against restic
    pkgs.sops
    # pkgs.rustic # testing against restic
    pkgs.backblaze-b2-tetos # b2 backup tool
    pkgs.msmtp # to send mails
    pkgs.systemctl-tui
    pkgs.nixpkgs-review
    pkgs.zola # needed in the post-receive hook of the blog !
    pkgs.yazi

    pkgs.wireguard-tools # for 'wg'

    config.services.nextcloud.occ
  ];

}
