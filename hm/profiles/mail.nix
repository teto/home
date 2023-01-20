{ pkgs, lib, config, ... }:
let

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
  mbsyncWrapper = pkgs.writeShellScriptBin "mbsync-wrapper" ''
    ${pkgs.isync}/bin/mbsync $@
    notmuch new
  '';

  # temporary solution since it's not portable
  getPassword = accountName:
    let
      # https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
      # 	  export PASSWORD_STORE_GPG_OPTS=" --default-cache-ttl 34560000"
      script = pkgs.writeShellScriptBin "pass-show" ''
        ${pkgs.pass}/bin/pass show "$@" | ${pkgs.coreutils}/bin/head -n 1
      '';
    in
    "${script}/bin/pass-show ${accountName}";

  my_tls = {
    enable = true;
    # certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
  };

  gpgModule = {
    key = "64BB678705EF85ABF7345F69BD024BD9C261596D";
    signByDefault = false;
  };

  fastmail =
    accountExtra //
    {
      gpg = gpgModule;
      flavor = "fastmail.com";
      astroid = { enable = true; };

      mbsync = mbsyncConfig // {
        remove = "both";
        sync = true;
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
        # TODO replace with pass
        # settings.password_command = "cat /home/teto/mujmap_password";
        settings.password_command = getPassword "perso/fastmail_mc_jmap";
        settings.config_dir = config.accounts.email.maildirBasePath;
      };


      primary = false;
      userName = "matthieucoudron@fastmail.com";
      realName = "Matthieu Coudron";
      address = "matthieucoudron@fastmail.com";

      # fastmail requires an app-specific password
      passwordCommand = getPassword "perso/fastmail_mc";

      # described here https://www.fastmail.com/help/technical/servernamesandports.html
      # imap = { host = "imap.fastmail.com"; tls = my_tls; };
      # smtp = { host = "smtp.fastmail.com"; tls = my_tls; };
      # smtp.tls.useStartTls = false;
    };


  nova = # {{{
    accountExtra //
    {
      astroid = { enable = true; };
      neomutt = {
        enable = false;
      };

      mbsync = mbsyncConfig // {
        remove = "both";
        extraConfig.account = {
          AuthMechs = "LOGIN";
        };
        sync = false;
      };
      msmtp.enable = true;
      notmuch = {
        enable = true;
      };

      primary = false;
      userName = "matthieu.coudron@novadiscovery.com";
      realName = "Matthieu coudron";
      address = "matthieu.coudron@novadiscovery.com";
      flavor = "gmail.com";
      smtp.tls.useStartTls = true;

      passwordCommand = getPassword "nova/mail";
    };
  # }}}


  gmail = accountExtra // {
    gpg = gpgModule;
    astroid.enable = true;

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
    userName = "mattator@gmail.com";
    realName = "Matt";
    address = "mattator@gmail.com";
    flavor = "gmail.com";
    smtp.tls.useStartTls = true;

    passwordCommand = getPassword "perso/gmail";
  };

in
{

  imports = [
    ./neomutt.nix
  ];

  home.packages = with pkgs; [
    isync
    mbsyncWrapper
  ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    inherit gmail;
    inherit fastmail;
    inherit nova;
  };


  # TODO conditionnally define these
  programs.notmuch = {
    enable = true;

    # dont add "inbox" tag
    new.tags = [ "unread" "inbox" ];
    # new.ignore = 
    search.excludeTags = [ "spam" ];

    hooks = {
      postNew = lib.concatStrings [
        (builtins.readFile ../../hooks_perso/post-new)
      ];
      # postInsert = 
    };
  };


  programs.msmtp = {
    enable = true;
    extraConfig = ''
      # this will create a default account which will then break the
      # default added via primary
      # syslog         on
    '';
  };




  # disabled for now, use mbsync instead
  programs.offlineimap = {
    enable = false;
    extraConfig.general = {
      # interval between updates (in minutes)
      autorefresh = 0;
    };

    # TODO get the version for keyring
    # remotepasseval
    pythonFile = ''
      from subprocess import check_output

      def get_pass(service, cmd):
        return subprocess.check_output(cmd, ).splitlines()[0]

    '';

    extraConfig.default = {
      # in bytes
      # The startdate option expects a date in the format yyyy-mm-dd.
      # can't be used with maxage
      startdate = "2020-04-01";
      maxsize = 20000;
      # works only with local folders of type maildir in daysA
      # maxage=30
      synclabels = true;
    };
  };

  programs.mbsync = {
    enable = true;
    # package = mbsyncWrapper;
  };

  services.mbsync = {
    enable = true; # disabled because it kept asking for my password
    verbose = true; # to help debug problems in journalctl
    frequency = "*:0/5";
    # TODO add a echo for the log
    postExec = "${pkgs.notmuch}/bin/notmuch new";
  };
  # copy load credential implem from https://github.com/NixOS/nixpkgs/pull/211559/files
  systemd.user.services.mbsync = {
    Service = {
      # TODO need DBUS_SESSION_BUS_ADDRESS 
      # --app-name="%N" toto
      Environment = ''DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"'';
      # TODO
      # FailureAction=''${pkgs.libnotify}/bin/notify-send "Failure"'';
      # TODO try to use LoadCredential
      # serviceConfig = {
      # DynamicUser = true;
      # PrivateTmp = true;
      # WorkingDirectory = "/var/lib/plausible";
      # StateDirectory = "plausible";
      # LoadCredential = [
      # "ADMIN_USER_PWD:${cfg.adminUser.passwordFile}"
      # "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
      # "RELEASE_COOKIE:${cfg.releaseCookiePath}"
      # ] ++ lib.optionals (cfg.mail.smtp.passwordFile != null) [ "SMTP_USER_PWD:${cfg.mail.smtp.passwordFile}"];
      # };
    };

  };

  # programs.muchsync = { };
  programs.mujmap = {
    enable = true;
  };

  programs.astroid = {
    enable = true;
    # TODO factor with my mbsyncwrapper ?
    pollScript = ''
      check-mail.sh gmail
    '';

    # I don't want it to trigger
    # P => main_window.poll
    extraConfig = {
      poll.interval = 0;
      # TODO use "killed"
      startup.queries = {
        # "Unread iij"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:coudron@iij.ad.jp";
        "Unread gmail" = "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:mattator@gmail.com";
        "Flagged" = "tag:flagged";
        # "Drafts"= "tag:draft";
        "fastmail" = "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:matthieucoudron@fastmail.com";
        # "nova"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:mattator@gmail.com";
        "ietf" = "tag:ietf";
        "gh" = "tag:gh";
      };
    };

    externalEditor = ''
      ${pkgs.kitty}/bin/kitty nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' '+set fo+=w' %1
    '';
  };

  # generate an addressbook that can be used later
  home.file."bin-nix/generate-addressbook".text = ''
    #!/bin/sh
    ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${addressBookFilename}
  '';
}
