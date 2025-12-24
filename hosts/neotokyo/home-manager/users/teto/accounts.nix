{ config, lib, 
pkgs
, withSecrets ? false
, secrets
, ... }:
let 
  # TODO read from a SOPS file
  getPasswordCommand = account: lib.strings.escapeShellArgs (lib.getPassword account);

  mailDirBasePath = "${config.home.homeDirectory}/maildir";

  gmail = {

      # Relative path of the inbox mail.
      folders.sent = "Sent";
      folders.trash = "Trash";

      msmtp.enable = true;

      primary = true;
      userName = secrets.accounts.mail.gmail_perso.address;
      realName = "Matt";
      address = secrets.accounts.mail.gmail_perso.address;
      flavor = "gmail.com";
      smtp.tls.useStartTls = true;

      # 
      passwordCommand = getPasswordCommand "perso/gmail";
    };
in
{
  
  email = {
    maildirBasePath = mailDirBasePath;

    accounts = lib.optionalAttrs withSecrets {
      inherit gmail;
    };


  };
}
