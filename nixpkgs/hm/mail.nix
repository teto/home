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


  # problem is I don't get the error
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
  # keyringProg = pkgs.python3.withPackages(ps: with ps; [ secretstorage keyring pygobject3]);


  # customMbsync = pkgs.writeScript ''
  #     # start
  #     ${pkgs.mbsync}/bin/mbsync -c /$@
  #     notmuch
  #   '';

  # stdenv.mkDerivation {
  #     name = "mbsync-with-hooks";
  #     buildInputs = [ pkgs.makeWrapper ];
  #     unpackPhase = "true";
  #     installPhase = ''
  #       mkdir -p $out/bin
  #       cp ${./scripts}/* $out/bin
  #       # for f in $out/bin/*; do
  #         wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gawk gnused nix diffutils ]}
  #       done
  #     '';
  # };
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

    mbsync = mbsyncConfig;
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
      enable = true;
      extraConfig.local = {
        # alot per-account extraConfig
        # The startdate option expects a date in the format yyyy-mm-dd.
        # can't be used with maxage
        # startdate = 2018-04-01
      };
      extraConfig.remote = {};
      # for now remove since it will generate
      # postSyncHookCommand = "notmuch new";
      # extraConfig =
      # seens to work without it ?
      # sslcacertfile= /etc/ssl/certs/ca-certificates.crt
      # newer offlineimap > 6.5.4 needs this
      # cert_fingerprint = 89091347184d41768bfc0da9fad94bfe882dd358
      # name translations would need to be done in both repositories, but reverse
      # prevent sync with All mail folder since it duplicates mail
      # folderfilter = lambda foldername: foldername not in ['[Gmail]/All Mail','[Gmail]/Spam','[Gmail]/Important']
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

  gmail =
  accountExtra //
  {
    gpg = gpgModule;
    astroid = {
      enable = true;
      # package =
    };

    getmail={
      enable = true;
      mailboxes = ["INBOX" "Sent" "Work"];
    };

    mbsync = mbsyncConfig;
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
      enable = true;
      extraConfig.local = {
        # alot per-account extraConfig
        # The startdate option expects a date in the format yyyy-mm-dd.
        # can't be used with maxage
        # startdate = 2018-04-01
      };
      extraConfig.remote = {};
      # for now remove since it will generate
      # postSyncHookCommand = "notmuch new";
      # extraConfig =
      # seens to work without it ?
      # sslcacertfile= /etc/ssl/certs/ca-certificates.crt
      # newer offlineimap > 6.5.4 needs this
      # cert_fingerprint = 89091347184d41768bfc0da9fad94bfe882dd358
      # name translations would need to be done in both repositories, but reverse
      # prevent sync with All mail folder since it duplicates mail
      # folderfilter = lambda foldername: foldername not in ['[Gmail]/All Mail','[Gmail]/Spam','[Gmail]/Important']
    };


    primary = true;
    userName = "mattator";
    realName = "Luke skywalker";
    address = "mattator@gmail.com";
    flavor = "gmail.com";
    smtp.tls.useStartTls = true;

    # to work around a git send-email problem
    # smtp.port = 587;

    # TODO this should be made default
    # maildirModule.path = "gmail";

    # keyring get gmail login
    # loginCommand =
    # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";
    # builtins.toString
    passwordCommand = getPassword "gmail";

    # contactCompletion = "notmuch address";
  };

in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    inherit gmail;
    inherit fastmail;


    # iij =
    #   accountExtra //
      # {
      # # juste pour tester, a supprimer
      # mbsync = mbsyncConfig;
      # msmtp.enable = true;
      # notmuch = {
      #   enable = true;
      # };
      # # offlineimap = {
      # #   enable = true;
      # #   extraConfig.local = ''
      # #     # alot per-account extraConfig
      # #     # The startdate option expects a date in the format yyyy-mm-dd.
      # #     # can't be used with maxage
      # #     # startdate = 2018-04-01
      # #     '';
      # #   # postSyncHookCommand = ''
      # #   #   '';
      # # };

      # userName = "coudron@iij.ad.jp";
      # realName = "Matthieu Coudron";
      # address = "coudron@iij.ad.jp";
      # # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup iij password";

      # passwordCommand = getPassword "iij/mail";
      # imap = { host = "imap-tyo.iiji.jp"; tls = my_tls; };
      # smtp = { host = "mbox.iiji.jp"; tls = my_tls; };
    # };
  };



   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;

     # extraConfig = {
     #   maildir = { synchronize_flags = "false"; };
     #  };
     # hopefully hooks should be per-account
     hooks = {

        # postInsert =

        # this is a trick since mbsync doesn't support
        # https://github.com/rycee/home-manager/issues/365
        # https://github.com/rycee/home-manager/pull/363
        # mbsync --all
        # while waiting to fix the real one !
        # preNew = ''
        #   mbsync -c /home/teto/dotfiles/config/mbsync/mbsyncrc gmail
        #   '';
        postNew = lib.concatStrings [
          (builtins.readFile ../../hooks_perso/post-new)
          (builtins.readFile ../../hooks_pro/post-new)
        ];
      };
     # extraConfig = {
     #   maildir = {
     #   };
     # };
   };

   programs.neomutt = {
      enable = true;
      # checkStatsInterval  = 60;
      # editor
      # theme: seems dangerous
      # macros = [ ];
      # binds = [ ];
      vimKeys = true;
      sidebar = {
        enable = false;
        # shortPath = false;
        # width = 60;
      };

      sort = "threads";

      # settings = {
      # };

      extraConfig = ''
        source $XDG_CONFIG_HOME/neomutt/test.rc
      '';

# # only available in neomutt
# set new_mail_command="notify-send --icon='/home/teto/.config/neomutt/mutt-48x48.png' \
# 'New Email' '%n new messages, %u unread.' &"
    #set sidebar_short_path
    # set sidebar_width = 25
# # Shorten mailbox names (truncate all subdirs)
# set sidebar_component_depth=1
# # Shorten mailbox names (truncate 1 subdirs)
# set sidebar_delim_chars="/"
# # Delete everything up to the last or Nth / character
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



   #   # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
   bindings = let
     refreshCommand = account: "shellescape 'mbsync ${account}'; refresh";
   in
     {
        global = {
          R = "reload";
          # look for ctrl+l
          "ctrl l" = "refresh";
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
          s = "toggletags --no-flush unread";
          "r g" = refreshCommand "gmail";
          "r f" = refreshCommand "fastmail";
          "$ g" = refreshCommand "gmail";
          "@" = refreshCommand "gmail";
        };
        thread = {
          a = "call hooks.apply_patch(ui)";
          "' '" = "fold; untag unread; move next unfolded";

          "s m" = "call hooks.save_mail(ui)";
          R = "reply --all";
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

    # // {
    #   # experimental
    #   tags = {
    #     # replied = {
    #     #   translated = "⏎";
    #     # };
    #     unread = {
    #       translated = "";
    #       # normal = "";
    #     };
    #   };
    #   extraConfigStructured = {
    #     edit_headers_whitelist = "Subject: toto";
    #   };
    # }
    # ;

     settings = {
      # attachment_prefix = ~/Downloads
        theme = "matt";
        mailinglists = "lisp@ietf.org, taps@ietf.org";
        editor_in_thread = false;
        auto_remove_unread = true;
        ask_subject = false;
        handle_mouse = true;
        thread_authors_replace_me = true;
        # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
      };
    };

# # TODO add as a string  extraConfigStr
# # some are from fontawesome
# # type i CTRTL-V u then unicode text im vim
# # signed / nix / neovim
# [tags]
  # # [[inbox]]
  # #   translated = 📥
  # [[unread]]
    # translated = 
  # [[replied]]
    # translated = ⏎
  # [[sent]]
    # translated = ↗
  # [[attachment]]
  # # 
    # translated = 
  # # [[lists]]
  # #   translated = 📃
  # # [[bug]]
  # #   translated = 🐜
  # #   normal = "", "", "dark red", "", "light red", ""
  # # TODO use a lock
  # [[encrypted]]
  # # 
# # 🔒
    # translated = 
  # [[github]]
    # translated = 
  # [[spam]]
    # translated = ♻
  # [[flagged]]
     #    # ⚑
     #  translated = 
     #  normal = "","","light red","","dark red",""
# '';

# [tags]

#   [[flagged]]
#       translated = ⚑
#       normal = "","","light red","","dark red",""
#   # [[inbox]]
#   #   translated = ➤#📨●◉↘
#   #   normal = "", "", "", "", "", ""
#   [[sent]]
#     translated =  ↗#⇗
#     normal = "","", "dark blue", "", "dark blue", ""
#   [[unread]]
#     translated = ""
#   [[replied]]
#     translated = ⏎
#     normal = "","", "dark cyan", "default", "dark blue", "default"
#   # [[encrypted]]
#   #   translated = 🔒#🔑#⚷
# #    normal = "", "", "", "", "#0ff", "#006"
#   # [[signed]]
#   #   translated = ®
#   #   normal = "", "", "", "", "", ""
#   # [[ring]]
#   #   translated = 💍#◉
#   # [[killed]]
#   #   translated = τ  # ☠
# # #    normal = "", "", "", "", g70, g27
#   # [[lists]]
#   #   translated = 📃#⎎

#   # [[attachment]]
#   #   translated = 📎
#   #   normal = "", "", "light blue", "", "light blue", ""

#   # [[bug]]
#   #   translated = 🐜
#   #   normal = "", "", "dark red", "", "light red", ""
#   [[todo]]
#     normal = "", "", white, "dark magenta", white, "dark magenta"
     # extraConfig =
     # # ''
     # #    body_mimetype=text/plain
     # #  # by default hooks.py but this makes it easier to edit
     # #  hooksfile = ~/.config/alot/apply_patch.py
     # #    # search_threads_sort_order = newest_first
# # # displayed_headers
     # #   # attachment_prefix = ~/Downloads
     # #     theme = "matt"
     # #   #  mailinglists = lisp@ietf.org, taps@ietf.org
     # #     editor_in_thread = False
     # #     auto_remove_unread = True
     # #     ask_subject = False
     # #     handle_mouse = True
     # #     thread_authors_replace_me = True
     # #     notify_timeout = 20 # -1 for unlimited
     # #     # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
     # #  ''
     # #  +
     #  ''


   # disabled for now, use mbsync instead
   programs.offlineimap = {
      enable = true;
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
    package = mbsyncWrapper;
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
    # sendemail.identity = "gmail";
  # };

  # programs.muchsync = {
  # };

  programs.astroid = {
    enable = true;
    # TODO factor with my mbsyncwrapper ?
    pollScript = ''
      mbsync gmail
    '';

    # startupQueries = [
    #     {
    #       "INBOX"= "tag:unread and not tag:deleted and not tag:muted and not tag:ietf";
    #       "Flagged"= "tag:flagged";
    #     }
    #     { "Drafts"= "tag:draft"; }
    #   ];

    # I don't want it to trigger
    # P => main_window.poll
    extraConfig = {
      poll.interval = 0;
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
