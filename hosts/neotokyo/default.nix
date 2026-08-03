{
  config,
  flakeSelf,
  secrets,
  # modulesPath,
  pkgs,
  lib,
  ...
}:
let
  haumea = flakeSelf.inputs.haumea;

  autoloadedProfiles = let 
      filteredSrc = flakeSelf.inputs.nix-filter {
        root = ./.;
        include = [
          # wrong ?
          "home-manager/"
          "users/users/root.nix"
          "users/default.nix"

          "ca.json"
          "sops.nix"
          "nix.nix"
          "nix.nix"
          "intermediate_ca.crt"
          "root_ca.crt"
          "systemd.nix"
          "networking.nix"
          "security.nix"
          "programs/msmtp.nix"
          "services/openssh.nix"
          "services/gitolite.nix"
          "services/llama-cpp.nix"
          "services/harmonia.nix"
          "services/jellyfin.nix"
          "services/restic.nix"
          "services/immich.nix"
          "services/step-ca.nix"
          "services/buildbot-nix.nix"
          "services/nixbot.nix"
          "services/transmission.nix"
          "services/headscale.nix"
        ];
        exclude = [
          # "teto"
          # "users"
          # "home-manager" # exclude home-manager because intputs are not the same: it must be imported differently
          # "root"
        ];
      };
  in
    { pkgs, ... }@args:
    haumea.lib.load {
       # error: lib.fileset.unions: Element 1 ("/nix/store/jx0avcglm965xdb8asiqgbzrlnr50mnl-source") is a string-like value, but it should be a file set or a path instead.
       #     Paths represented as strings are not supported by `lib.fileset`, use `lib.sources` or derivations instead.
      src = lib.fileset.unions [
        ../../nixos/profiles/desktop/root_ca.crt
        (lib.sources filteredSrc)
      ];

      inputs = args // {
        osConfig = config;
        # inputs = flakeSelf.inputs;
      };
      transformer = [
        haumea.lib.transformers.liftDefault
        (haumea.lib.transformers.hoistLists "_imports" "imports")
      ];
    };

in
{

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

  # services.dbus.implementation = "dbus";

  imports = [

    ./ovh.nix

    autoloadedProfiles
    ./disko-config.nix

    flakeSelf.nixosProfiles.systemd-on-failure-service

    flakeSelf.inputs.disko.nixosModules.disko
    flakeSelf.nixosModules.teto-nogui
    flakeSelf.nixosModules.default-hm

    flakeSelf.nixosProfiles.server
    flakeSelf.nixosProfiles.ntp
    flakeSelf.nixosProfiles.nix-daemon

    # ./nix.nix
    ./hardware.nix

    # move to autoloaded

    # ./services/openssh.nix
    # ./services/sshguard.nix
    # ./services/gitolite.nix
    ./services/nextcloud.nix
    ./services/postgresqlBackup.nix
    ./services/nginx.nix
    # ./services/immich.nix
    # ./services/restic.nix

    # testing
    # ./services/vaultwarden.nix
    # ./services/linkwarden.nix
    # ./services/hedgedoc.nix

    # ../../nixos/modules/hercules-ci-agents.nix

    flakeSelf.nixosProfiles.server

    # TODO remove once nixbot succeeds
    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-master
    flakeSelf.inputs.buildbot-nix.nixosModules.buildbot-worker
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

  environment.systemPackages = [
    # flakeSelf.inputs.transgression-tui.packages.${pkgs.stdenv.hostPlatform.system}.transgression-tui
    pkgs.tremc
    pkgs.restic # testing against restic
    pkgs.sops
    # pkgs.rustic # testing against restic
    pkgs.backblaze-b2-tetos
    pkgs.msmtp # to send mails
    pkgs.systemctl-tui
    pkgs.nixpkgs-review
    pkgs.zola # needed in the post-receive hook of the blog !
    pkgs.yazi
    pkgs.wireguard-tools # for 'wg'

  ];

  # create a service to monitor new blog

  # services.gitolite.adminPubkey = secrets.gitolitePublicKey;

}
