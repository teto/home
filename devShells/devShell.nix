{
  pkgs,
  secrets,
  self,
  ...
}:
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
      # stdenv.hostPlatform.system
      self.inputs.deploy-rs.packages.${system}.deploy-rs
      expect # to pipe into deploy-rs
      fzf # for just's "--select"
      git-crypt # to run `git-crypt export-key`
      just # to run justfiles

      lua5_1 # for tests
      nix-output-monitor
      # nodejs # what for ?
      termscp-matt
      treefmt-home # use formatter instead ?
      ripgrep
      rustic # testing against restic
      sops # to decrypt secrets
      ssh-to-age

      self.inputs.nixos-anywhere.packages.${system}.nixos-anywhere
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
