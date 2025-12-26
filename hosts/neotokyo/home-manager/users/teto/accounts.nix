{
  config,
  lib,
  pkgs,
  osConfig,
  withSecrets ? false,
  secrets,
  ...
}:
let
  # TODO read from a SOPS file
  # getPasswordCommand = account: lib.strings.escapeShellArgs (lib.getPassword account);

  mailDirBasePath = "${config.home.homeDirectory}/maildir";

  # gmail = {
  #     # Relative path of the inbox mail.
  #     folders.sent = "Sent";
  #     folders.trash = "Trash";
  #
  #     msmtp.enable = true;
  #
  #     primary = true;
  #     userName = secrets.accounts.mail.gmail_perso.address;
  #     realName = "Matt";
  #     address = secrets.accounts.mail.gmail_perso.address;
  #     flavor = "gmail.com";
  #     smtp.tls.useStartTls = true;
  #
  #     passwordCommand = getPasswordCommand "perso/gmail";
  #   };

  fastmail = {
    primary = true;
    userName = secrets.accounts.mail.fastmail_perso.login;
    realName = secrets.users.teto.realName;
    address = secrets.accounts.mail.fastmail_perso.email;

    # fastmail requires an app-specific password
    passwordCommand = "cat ${osConfig.sops.secrets."fastmail_msmtp".path}";
    # getPasswordCommand "perso/fastmail_mc/password";
    flavor = "fastmail.com";

    msmtp.enable = true;
  };

in
{

  email = {
    maildirBasePath = mailDirBasePath;

    accounts = lib.optionalAttrs withSecrets {
      inherit fastmail;
    };

  };
}
