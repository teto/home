{
  pkgs,
  secrets,
  self,
  ...
}:
let
  myLisp = pkgs.sbcl.withPackages (
    ps: with ps; [
      # lips utilities (logging etc)
      # https://alexandria.common-lisp.dev/draft/alexandria.html
      alexandria
      adopt # for parsers
      linedit
    ]
  );
in
pkgs.mkShell {
  name = "dotfiles-shell";

  # - I need sops to edit my secrets
  # - git-crypt
  buildInputs =
    with pkgs;
    [
      age
      pkgs.bitwarden-cli # to sync passwords
      dmidecode
      qrencode # to plot qrcodes and "show" secrets to smartphone
      self.inputs.deploy-rs.packages.${stdenv.hostPlatform.system}.deploy-rs
      expect # to pipe into deploy-rs
      fzf # for just's "--select"
      git-crypt # to run `git-crypt export-key`
      just # to run justfiles

      lua5_1 # for tests
      myLisp
      nix-output-monitor
      # nodejs # what for ?
      # termscp-matt
      openssl_3 # to inspect certificates
      treefmt-home # use formatter instead ?
      ripgrep
      rustic # testing against restic
      sops # to decrypt secrets
      ssh-to-age

      # to generate certificates
      step-cli
      step-ca

      self.inputs.nixos-anywhere.packages.${stdenv.hostPlatform.system}.nixos-anywhere
      disko

      # boot debug
      # chntpw # broken to edit BCD (Boot configuration data) from windows
      efibootmgr

      # yubikey deps
      smartmontools # for smartctl
      pamtester # to test yubikey https://nixos.wiki/wiki/Yubikey
      pam_u2f # pamu2fcfg > ~/.config/Yubico/u2f_keys

      magic-wormhole-rs # to transfer secrets
      wormhole-rs # "wormhole-rs send"
      wireguard-tools # for 'wg'

      lazyrsync # to exchange secrets
      pkgs.git-branch-monitor
    ]
    ++ [
      # removed because it was using IFD and we use firefox policies instead
      # self.inputs.firefox2nix.packages.${system}.default
    ];

  # TODO set SOPS_A
  shellHook =
    let
      # --from ${}
      generatedJustfile = pkgs.writeText "justfile.generated" ''
        test-msmtp-send-mail:
            # TODO generate the mail headers
            cat contrib/2025-05-04-21.38.53.mail | msmtp --read-envelope-from --read-recipients -afastmail ${secrets.users.teto.email}
      '';

    in
    ''
      export SOPS_AGE_KEY_FILE=$PWD/secrets/age.key
      # TODO rely on scripts/load-restic.sh now ?
      export RESTIC_REPOSITORY_FILE=/run/secrets/restic/teto-bucket
      export RESTIC_PASSWORD_FILE=
      source config/bash/aliases.sh

      ln -sf ${generatedJustfile} justfile.generated
      echo "Run just ..."
    '';
}
