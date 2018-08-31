{ pkgs, lib, config, ... }:
let 
  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';

    create = "maildir";
  };
  my_tls = {
    enable = true;
    # certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
  };
  # keyringProg = pkgs.python3.withPackages(ps: with ps; [ secretstorage keyring pygobject3]);
in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    gmail = {

      mbsync = mbsyncConfig;
      alot = { enable = true; };
      # astroid = { enable = true; };
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
        # postSyncHookCommand = ''

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
      imap = {
        # host = "imap.gmail.com";
        tls = my_tls;
      };

      smtp = {
        # host = "smtp.gmail.com";
        # port =  587;
        tls = my_tls;
      };

      # TODO this should be made default
      # maildirModule.path = "gmail";

      # keyring get gmail login
      # loginCommand = 
      passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";
      # maildir = 

      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      # contactCompletion = "notmuch address";
    };

    iij = {
      mbsync = mbsyncConfig;
      # alot = { enable = true; };
      msmtp.enable = true;
      notmuch = { 
        enable = true;
      };
      # offlineimap = {
      #   enable = true;
      #   extraConfig.local = ''
      #     # alot per-account extraConfig
      #     # The startdate option expects a date in the format yyyy-mm-dd.
      #     # can't be used with maxage
      #     # startdate = 2018-04-01
      #     '';

      #   # postSyncHookCommand = ''
      #   #   '';
      # };

      userName = "coudron@iij.ad.jp";
      realName = "Matthieu Coudron";
      address = "coudron@iij.ad.jp";
      passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup iij password";
      imap = { host = "imap-tyo.iiji.jp"; tls = my_tls; };
      smtp = { host = "mbox.iiji.jp"; tls = my_tls; };
      # getLogin = "";
    };


    # for vdirsyncer
    # zaclys = {
    # }
  };



   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
     # hopefully hooks should be per-account
     hooks = {

        # postInsert = 
        preNew = ''
          '';
        postNew = lib.concatStrings [ 
          (builtins.readFile ../hooks_perso/post-new)
          (builtins.readFile ../hooks_pro/post-new)
        ];
      };
     # extraConfig = {
     #   maildir = {
     #   };
     # };
   };

   programs.msmtp = {
     enable = true;
     extraConfig = ''
      syslog         on

      defaults
     '';
   };

   programs.alot = {
     enable = true;

   #   # sendCommand = config.programs.msmtp.sendCommand;
   #   # mta type
   #   # contactCompletionCommand = ''
   #   # '';

   #   # createAliases=true;
   #   # generate alias
   #   # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
   #   # w = pipeto urlscan 2> /dev/null

   #   # initial_command = bufferlist; taglist; search foo; search bar; buffer 0
   #   #  mailinglists = lisp@ietf.org, taps@ietf.org 
   #   # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
   #   bindings = {
   #      global = {
   #        R = "reload";
   #        "/" = "prompt search ";
   #      };
   #      thread = {
   #        a = "call hooks.apply_patch(ui)";
   #        "' '" = "fold; untag unread; move next unfolded";
   #      };
   #    };

# # editor_command
# # editor_spawn
# # attachment_prefix = ~/Downloads
   #      # theme = "solarized";
     extraConfig = {
       # foireux comme option
       # convertir
        editor_in_thread = false;
        auto_remove_unread = true;
        ask_subject = false;
        handle_mouse = true;
      };

# # TODO add as a string  extraConfigStr
# # [tags]
# #   [[inbox]]
# #     translated = 📥
# #   [[unread]]
# #     translated = ✉
# #   [[replied]]
# #     translated = ⏎
# #   [[sent]]
# #     translated = ↗
# #   [[attachment]]
# #     translated = 📎
# #   [[lists]]
# #     translated = 📃
# #   [[bug]]
# #     translated = 🐜
# #     normal = "", "", "dark red", "", "light red", ""
# #   [[encrypted]]
# #     translated = 🔒
# #   [[spam]]
# # translated = ♻
   };


   # disabled for now, use mbsync instead
   programs.offlineimap = {
      enable = true;
      extraConfig.general = {
        # interval between updates (in minutes)
        autorefresh=0;
      };
      extraConfig.default = {

        # in bytes
        # The startdate option expects a date in the format yyyy-mm-dd.
        # can't be used with maxage
        startdate = "2018-04-01";
        maxsize=2000000;
        # works only with local folders of type maildir in daysA
        # maxage=30
        synclabels= true;
      };
   };

  programs.mbsync = {
    enable = true;
  };

# [Account iij] # {{{
# localrepository = iij-local
# remoterepository = iij-remote
# maxage=10
# # presynchook=imapfilter
# # TODO notify user run a script that will launch tag
# postsynchook=notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc_pro new

# [Repository iij-local]
# type = Maildir
# localfolders = ~/maildir/iij

# [Repository iij-remote]
# type = IMAP
# # imap-tyo.iiji.jp
# # imap911.iiji.jp
# remotehost = imap-tyo.iiji.jp
# # ssl=yes
# remoteuser = coudron@iij.ad.jp
# realdelete = no
# sslcacertfile = /etc/ssl/certs/ca-certificates.crt
#/bin/secret-tool # on gmail just remove tags, you really need to move files to trash folder
# maxconnections = 3
# # }}}
     #   '';
}
