{ flakeSelf
, pkgs
, lib
, config
, withSecrets
, secretsFolder
, ... }:
{

  imports = [

    flakeSelf.homeProfiles.common
    flakeSelf.homeModules.fzf
    flakeSelf.homeModules.teto-zsh
    flakeSelf.homeModules.teto-desktop
    flakeSelf.homeModules.yazi
    flakeSelf.homeModules.neovim
    flakeSelf.homeModules.services-mujmap

  ] ++ lib.optionals withSecrets [
    flakeSelf.homeModules.nova
  ]
  ;

  services.mujmap = {
    enable = true;
    verbose = true;

    package = pkgs.mujmap-unstable;
  };

  home.packages = [
    pkgs.trurl  # used to parse url in the firefox-router executable
  ];

  # conditionnally define it
  systemd.user.services.mujmap-fastmail.Service = {
    Environment = [
      "PATH=${
        pkgs.lib.makeBinPath [
          pkgs.pass-teto
          pkgs.bash
        ]
      }"
    ];
    # TODO add notmuch_CONFIG ?
  };


  # services.vdirsyncer = {
  #   enable = true;
  # };

  # TODO move somewhere else close to mbsync
  # copy load credential implem from https://github.com/NixOS/nixpkgs/pull/211559/files
  # systemd.user.services.mbsync
  # systemd.user.services.mbsync = lib.mkIf config.services.mbsync.enable {
  #   Service = {
  #     # TODO need DBUS_SESSION_BUS_ADDRESS
  #     # --app-name="%N" toto
  #     Environment = [ ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'' ];
  #     # SetCredentialEncrypted=secrets.accounts.mail.fastmail_perso;
  #     # easier to update the file then regenarate the nix code
  #     # ImportCredential="fastmail_perso:/home/teto/home/secrets/mail.secret";
  #     LoadCredential = "fastmail_perso:${secretsFolder}/mail.secret";
  #     # LoadCredentialEncrypted="fastmail_perso:/home/teto/home/secrets/mail.secret";
  #     # TODO
  #     # FailureAction=''${pkgs.libnotify}/bin/notify-send "Failure"'';
  #     # TODO try to use LoadCredential
  #     # serviceConfig = {
  #     # DynamicUser = true;
  #     # PrivateTmp = true;
  #     # WorkingDirectory = "/var/lib/plausible";
  #     # StateDirectory = "plausible";
  #     # LoadCredential = [
  #     # "ADMIN_USER_PWD:${cfg.adminUser.passwordFile}"
  #     # "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
  #     # "RELEASE_COOKIE:${cfg.releaseCookiePath}"
  #     # ] ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [ "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"];
  #     # };
  #   };
  # };


  home.language = {
    # monetary =
    # measurement =
    # numeric =
    # paper =
    time = "fr_FR.utf8";
  };


  # programs.zsh = {
  # initExtraBeforeCompInit = # zsh
  # ''
  #   # zsh searches $fpath for completion files
  #   fpath+=( $ZDOTDIR/completions )
  # '';
  #
  #
  #   # test for
  #   # - https://www.reddit.com/r/neovim/comments/17dn1be/implementing_mru_sorting_with_minipick_and_fzflua/
  #   # - https://lib.rs/crates/fre
  #   # todo convert it to an option ?
  #   initExtra = ''
  #     fre_chpwd() {
  #       fre --add "$(pwd)"
  #     }
  #     typeset -gaU chpwd_functions
  #     chpwd_functions+=fre_chpwd
  #
  #      # if [ -f "$ZDOTDIR/zshrc" ]; then
  #      source $ZDOTDIR/zshrc
  #      # fi
  #
  #      # see https://github.com/jeffreytse/zsh-vi-mode for integration
  #      # TODO you can also use home-manager's built-in "plugin" feature:
  #   '';
  #
  # };

  # xdg.configFile."teto-utils/lib.sh".text = ''
  xdg.configFile."bash/lib.sh".text = ''
    TETO_SECRETS_FOLDER=${secretsFolder}
  '';

}
