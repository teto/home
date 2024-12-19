{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let

  getPasswordCommand = account: lib.strings.escapeShellArgs (pkgs.tetoLib.getPassword account);

  # file generated by generate-addressbook
  addressBookFilename = "${config.xdg.cacheHome}/addressbook.json";

  mbsyncConfig = {
    enable = true;
    extraConfig.channel = {
      # unlimited
      # when setting MaxMessages, set ExpireUnread
      MaxMessages = 20000;
      # size[k|m][b]
      MaxSize = "1m";
      CopyArrivalDate = "yes"; # Keeps the time stamp based message sorting intact.
    };
    create = "maildir"; # create missing mailboxes
    expunge = "both";
  };

  accountExtra = {
    neomutt = {
      enable = true;
      sendMailCommand = "msmtpq --debug --read-envelope-from --read-recipients";
    };

    # set new_mail_command = ""
    # onNewMailCommand = mkOption {
    #   type = types.nullOr types.str;
    #   description = ''
    #     <command>msmtpq --read-envelope-from --read-recipients</command>.
    #   '';
    # };
    alot = {
      # TODO pass mon fichier a moi
      contactCompletion = {
        type = "shellcommand";
        command = "cat ${addressBookFilename}";
        regexp =
          "'\\[?{"
          + ''"name": "(?P<name>.*)", ''
          + ''"address": "(?P<email>.+)", ''
          + ''"name-addr": ".*"''
          + "}[,\\]]?'";
        shellcommand_external_filtering = "False";
      };
    };

  };

  # problem is I don't get the error/can't interrupt => TODO use another one
  # mbsyncWrapper = pkgs.writeShellScriptBin "mbsync-wrapper" ''
  #   ${pkgs.isync}/bin/mbsync $@
  #   notmuch new
  # '';

  # my_tls = {
  #   enable = true;
  #   # certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #   certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
  # };

  gpgModule = {
    key = "64BB678705EF85ABF7345F69BD024BD9C261596D";
    signByDefault = false;
  };

  fastmail = accountExtra // {
    gpg = gpgModule;
    flavor = "fastmail.com";
    astroid = {
      enable = true;
    };

    mbsync = mbsyncConfig // {
      enable = false; # mujmap is better at it
      remove = "both";
      # sync = true;
    };

    # folders.sent = "[Gmail]/Sent Mail";

    msmtp.enable = true;
    aerc.enable = true;
    notmuch = {
      enable = true;
      # fqdn = "fastmail.com";
    };
    mujmap = {
      enable = true;
      # session_url Mutually exclusive with `fqdn`.
      # fqdn = null;
      settings.fqdn = "fastmail.com";
      # TODO replace with pass
      # settings.password_command = "cat /home/teto/mujmap_password";
      # look at https://github.com/elizagamedev/mujmap/blob/main/mujmap.toml.example 
      # for example
      settings.username = secrets.accounts.mail.fastmail_perso.email;
      # settings.password_command = getPasswordCommand "perso/fastmail_mc_jmap";
      settings.password_command = "${pkgs.pass}/bin/pass show perso/fastmail_mc_jmap";
      settings.config_dir = config.accounts.email.maildirBasePath;
      # 
      # settings.session_url = "https://api.fastmail.com/.well-known/jmap";
      # settings.session_url = "https://api.fastmail.com/jmap/session";
      # check example at https://github.com/elizagamedev/mujmap/blob/main/mujmap.toml.example
      # settings.timeout = 5
    };

    primary = false;
    userName = secrets.accounts.mail.fastmail_perso.login;
    realName = secrets.users.teto.realName;
    address = secrets.accounts.mail.fastmail_perso.email;

    # fastmail requires an app-specific password
    passwordCommand = getPasswordCommand "perso/fastmail_mc/password";

    # described here https://www.fastmail.com/help/technical/servernamesandports.html
    # imap = { host = "imap.fastmail.com"; tls = my_tls; };
    # smtp = { host = "smtp.fastmail.com"; tls = my_tls; };
    # smtp.tls.useStartTls = false;
  };

  nova = # {{{
    accountExtra // {
      astroid = {
        enable = true;
      };
      neomutt = {
        enable = false;
      };

      mbsync = mbsyncConfig // {
        remove = "both";
        extraConfig.account = {
          AuthMechs = "LOGIN";
        };
        # sync = false;
      };
      msmtp.enable = true;
      notmuch = {
        enable = true;
      };

      primary = false;
      userName = secrets.accounts.mail.nova.email;
      realName = "Matthieu coudron";
      address = secrets.accounts.mail.nova.email;
      flavor = "gmail.com";
      smtp.tls.useStartTls = true;

      passwordCommand = getPasswordCommand "nova/mail";
    };
  # }}}

  gmail = accountExtra // {
    gpg = gpgModule;
    astroid.enable = true;
    thunderbird.enable = true;

    # folders.drafts = "[Gmail]/Drafts";
    # folders.inbox = "Inbox";

    # Relative path of the inbox mail.
    folders.sent = "Sent";
    folders.trash = "Trash";

    # CopyArrivalDate
    mbsync = mbsyncConfig // {
      remove = "both";
      # how to destroy on gmail ?
      # expunge = "both";
      # Exclude everything under the internal [Gmail] folder, except the interesting folders
      # Patterns * ![Gmail]* "[Gmail]/Sent Mail" "[Gmail]/Starred" "[Gmail]/All Mail"
      # "[Gmail]/Inbox"
      # patterns = ["* ![Gmail]*" "[Gmail]/Sent Mail" "[Gmail]/Starred" ];
      # to be able to create drafts ?
      create = "both";
      groups.personal = {
        channels = {
          inbox = {
            farPattern = "";
            nearPattern = "";
            extraConfig = {
              Create = "Both";
            };
          };
          sent = {
            # farPattern = config.accounts.email.accounts.gmail.folders.sent;
            farPattern = "[Gmail]/Sent Mail";
            nearPattern = "Sent";
            extraConfig = {
              Create = "Both";
            };
          };
          trash = {
            farPattern = config.accounts.email.accounts.gmail.folders.trash;
            # farPattern = "[Gmail]/Trash";
            nearPattern = "Trash";
            extraConfig = {
              Create = "Both";
            };
          };
          # starred = {
          #   farPattern = "[Gmail]/Starred";
          #   nearPattern = "Starred";
          # };
          # drafts = {
          #   farPattern = config.accounts.email.accounts.gmail.folders.drafts;
          #   nearPattern = "Drafts";
          # };
          # spam = {
          #   farPattern = config.accounts.email.accounts.gmail.folders.drafts;
          #   nearPattern = "Spam";
          # };
        };
      };
      extraConfig.account = {
        # PipelineDepth = 50;
        # AuthMechs = "LOGIN";
        # SSLType = "IMAPS";
        # SSLVersions = "TLSv1.2";
      };
      extraConfig.remote = {
        Account = "gmail";
      };
      extraConfig.local = {
        SubFolders = "Verbatim";
      };
    };

    msmtp.enable = true;

    notmuch.enable = true;

    primary = true;
    userName = secrets.accounts.mail.gmail_perso.address;
    realName = "Matt";
    address = secrets.accounts.mail.gmail_perso.address;
    flavor = "gmail.com";
    smtp.tls.useStartTls = true;

    passwordCommand = getPasswordCommand "perso/gmail";
  };

in
{

  imports = [
    ../../../../../hm/profiles/neomutt.nix
    ./programs/aerc.nix
    ./programs/astroid.nix
    ./programs/msmtp.nix
    ./programs/mujmap.nix
    # ./programs/mbsync.nix  # using mujmap instead ?
    ./programs/notmuch.nix
    ./services/mbsync.nix # using mujmap instead ?
  ];

  services.mujmap = {
    enable = true;
    package = pkgs.mujmap-unstable;
  };

  home.packages = with pkgs; [
    isync
    mujmap-unstable
    # meli-git # broken jmap mailreader
  ];

  systemd.user.services.mujmap-fastmail.Service = {
    Environment = "PATH=${pkgs.lib.makeBinPath [ pkgs.pass-teto ]}";
  };

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    inherit gmail;
    inherit fastmail;
    inherit nova;
  };

  # generate an addressbook that can be used later
  home.file."bin-nix/generate-addressbook".text = ''
    #!/bin/sh
    ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${addressBookFilename}
  '';

  # order matters
  home.file.".mailcap".text = ''
    application/pdf; evince '%s';
    # pdftotext
    # wordtotext
    # ppt2text
    # download script mutt_bgrun
    #application/pdf; pdftohtml -q -stdout %s | w3m -T text/html; copiousoutput
    #application/msword; wvWare -x /usr/lib/wv/wvHtml.xml %s 2>/dev/null | w3m -T text/html; copiousoutput
    text/calendar; khal import '%s'
    text/*; less '%s';
    # khal import [-a CALENDAR] [--batch] [--random-uid|-r] ICSFILE
    image/*; eog '%s';

        text/html;  ${pkgs.w3m}/bin/w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
        application/*; xdg-open "%s"
        */*; xdg-open "%s"
  '';

}
