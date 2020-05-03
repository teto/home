{ pkgs, lib, config, ... }:
let

  # file generated by generate-addressbook
  addressBookFilename = "${config.xdg.cacheHome}/addressbook.json";

  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';
    extraConfig.channel = {
      # unlimited
      # when setting MaxMessages, set ExpireUnread
      MaxMessages = 0;
      # size[k|m][b]
      MaxSize = "1m";
    };
    # postSyncHookCommand = "notmuch new";
    # create missing mailboxes
    create = "maildir";

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
      script = pkgs.writeShellScriptBin "pass-show" ''
      ${pkgs.pass}/bin/pass show "$@" | head -n 1
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
    astroid = { enable = true; };

    getmail={
      enable = true;
      mailboxes = ["INBOX" "Sent" "Work"];
    };

    mbsync = mbsyncConfig // { remove = "both"; };
    msmtp.enable = true;
    notmuch = {
      enable = true;
        # hooks = {
        #   # postInsert =
        #   preNew = ''
        #     '';
        #   postNew = lib.concatStrings [
        #     (builtins.readFile ../hooks_perso/post-new)
        #     (builtins.readFile ../hooks_pro/post-new)
        #   ];
        # };
    };

    offlineimap = {
      enable = false;
      extraConfig.local = { };
      extraConfig.remote = {};
    };


    primary = false;
    userName = "matthieucoudron@fastmail.com";
    realName = "Matthieu Coudron";
    address = "matthieucoudron@fastmail.com";

    # to work around a git send-email problem
    # smtp.port = 587;

    # TODO this should be made default
    # maildirModule.path = "gmail";

    # keyring get gmail login
    # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";

    # fastmail requires an app-specific password
    passwordCommand = getPassword "perso/fastmail_mc";

    # described here https://www.fastmail.com/help/technical/servernamesandports.html
    imap = { host = "imap.fastmail.com"; tls = my_tls; };
    smtp = { host = "smtp.fastmail.com"; tls = my_tls; };
    # smtp.tls.useStartTls = false;
  };


  nova = # {{{
  accountExtra //
  {
    astroid = { enable = true; };
    neomutt = {
      enable = false;
    };

    mbsync = mbsyncConfig // { remove = "both"; };
    msmtp.enable = true;
    notmuch = {
      enable = true;
        # hooks = {
        #   # postInsert =
        #   preNew = ''
        #     '';
        #   postNew = lib.concatStrings [
        #     (builtins.readFile ../hooks_perso/post-new)
        #     (builtins.readFile ../hooks_pro/post-new)
        #   ];
        # };
    };

    primary = false;
    userName = "matthieu.coudron@novadiscovery.com";
    realName = "Matthieu coudron";
    address = "matthieu.coudron@novadiscovery.com";
    flavor = "gmail.com";
    smtp.tls.useStartTls = true;

    passwordCommand = getPassword "nova_mail";
  };
  # }}}


  gmail =
  accountExtra //
  {
    gpg = gpgModule;
    astroid = {
      enable = true;
      # package =
    };

    # getmail={
    #   enable = true;
    #   mailboxes = ["INBOX" "Sent" "Work"];
    # };

    mbsync = mbsyncConfig // {
      remove = "both";
      # how to destroy on gmail ?
      # expunge = "both";
      # Exclude everything under the internal [Gmail] folder, except the interesting folders
# Patterns * ![Gmail]* "[Gmail]/Sent Mail" "[Gmail]/Starred" "[Gmail]/All Mail"
      # "[Gmail]/Inbox"
      patterns = ["* ![Gmail]*" "[Gmail]/Sent Mail" "[Gmail]/Starred" ];
      # to be able to create drafts ?
      create = "both";
    };

    msmtp.enable = true;

    notmuch.enable = true;

    primary = true;
    userName = "mattator";
    realName = "Matt ";
    address = "mattator@gmail.com";
    flavor = "gmail.com";
    smtp.tls.useStartTls = true;

    # loginCommand =
    # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";
    # builtins.toString
    passwordCommand = getPassword "gmail";
  };

in
{

  imports = [
    ./neomutt.nix
  ];

  home.packages = with pkgs; [
    isync
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
     new.tags = ["unread"];

     # hopefully hooks should be per-account
     hooks = {
        # this is a trick since mbsync doesn't support
        # https://github.com/rycee/home-manager/issues/365
        # https://github.com/rycee/home-manager/pull/363
        postNew = lib.concatStrings [
          (builtins.readFile ../../hooks_perso/post-new)
          # (builtins.readFile ../../hooks_pro/post-new)
        ];
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

  # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
  # w = pipeto urlscan 2> /dev/null

   programs.alot = {
     enable = true;

     # Hooks are python callables that live in a module specified by hooksfile in the config.
     hooks = builtins.readFile ../../config/alot/apply_patch.py;

    # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
    bindings = let
      refreshCommand = account: "shellescape 'check-mail.sh ${account}'; refresh";
    in
      {
          global = {
            R = "reload";
            # look for ctrl+l
            "ctrl l" = "flush; refresh";
            # "ctrl l" = "flush";
            "/" = "prompt 'search '";
            t = "taglist";
            Q = "exit";
            q = "bclose";
            "." = "repeat";
            # n = "compose";
            n = "namedqueries";
            "ctrl f" = "move halfpage down";
            "ctrl b" = "move halfpage up";

            # otherwise toggling tags makes UI sluggish
            # https://github.com/pazz/alot/issues/307
            # call `flush` to refresh
            s = "toggletags --no-flush unread";
            d = "toggletags --no-flush killed";

            "r g" = refreshCommand "gmail";
            "r f" = refreshCommand "fastmail";
            "r n" = refreshCommand "nova";

            "@" = refreshCommand "gmail";
          };
          thread = {
            a = "call hooks.apply_patch(ui)";
            "' '" = "fold; untag unread; move next unfolded";

            "s m" = "call hooks.save_mail(ui)";
            R = "reply --all";
            # TODO add a vimkeys component to alot
            "z C" = "fold *";
            "z c" = "fold";
            "z o" = "unfold";
            "z O" = "unfold *";
          };
          search = {
            t = "toggletags todo";
            # t = "toggletags todo";
            l = "select";
            right = "select";
            # star it
            # s = "toggletags todo";
          };
      };

      tags = {
        replied = {
          translated = "⏎";
        };
        unread = {
          translated = "";
          # normal = "";
        };
        lists = {
          translated = "📃";
        };

        attachment = {
          translated = "📎";
          # normal = "", "", "light blue", "", "light blue", ""
        };

        bug = {
          translated = "🐜";
            # normal = "", "", "dark red", "", "light red", ""
        };
        encrypted.translated= "🔒";
    # translated = 
        github = {
          translated = "";
        };
        spam.translated = "♻";
        flagged = {
      #       translated = ⚑
          translated = "";
          #  normal = "","","light red","","dark red",""
        };

        #   [[sent]]
        #     translated =  ↗#⇗
        #     normal = "","", "dark blue", "", "dark blue", ""
      };

    settings = {
      # attachment_prefix = ~/Downloads
      # edit_headers_whitelist = "Subject: toto";
      theme = "matt";
      mailinglists = "lisp@ietf.org, taps@ietf.org";
      editor_in_thread = false;
      auto_remove_unread = true;
      ask_subject = false;
      handle_mouse = true;
      thread_authors_replace_me = true;
        # notify_timeout = 20; # -1 for unlimited

      initial_command = "search tag:unread AND NOT tag:killed";
        # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
      };
    };



   # disabled for now, use mbsync instead
   programs.offlineimap = {
     enable = false;
     extraConfig.general = {
        # interval between updates (in minutes)
        autorefresh=0;
      };

      # TODO get the version for keyring
      # remotepasseval
      pythonFile = ''
        from subprocess import check_output

        def get_pass(service, cmd):
          return subprocess.check_output(cmd, ).splitlines()[0]

      # def get_pass(account):
      #     return check_output("pass Mail/" + account, shell=True).splitlines()[0]
      '';

      extraConfig.default = {

        # in bytes
        # The startdate option expects a date in the format yyyy-mm-dd.
        # can't be used with maxage
        startdate = "2018-04-01";
        maxsize=20000;
        # works only with local folders of type maildir in daysA
        # maxage=30
        synclabels= true;
      };
    };

    programs.mbsync = {
      enable = true;
    };

    services.mbsync = {
      enable = false;  # disabled because it kept asking for my password
    # configFile = ;
    # package = ;
    # preExec =
    # postExec =
    # verbose
    verbose = true;  # to help debug problems in journalctl
    frequency =  "*:0/5";
  };


  # enrich definition given in
  # programs.git = {
  #    sendemail.identity = "gmail";
  # };

  # programs.muchsync = { };

  programs.astroid = {
    enable = false;
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
        "Unread iij"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:coudron@iij.ad.jp";
        "Unread gmail"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf and to:mattator@gmail.com";
        "Flagged"= "tag:flagged";
        # "Drafts"= "tag:draft";
        "ietf"= "tag:ietf";
        # "gh"= "tag:gh";
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


  # NOTMUCH_CONFIG = "${config.xdg.configHome}/notmuch/notmuchrc";
}
