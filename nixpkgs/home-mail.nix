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
  keyringProg = pkgs.python3.withPackages(ps: with ps; [ secretstorage keyring pygobject3]);
in
{
  accounts.email.accounts = {
    gmail = {

      mbsync = mbsyncConfig;
      alot = {
        enable = true;
      };
      notmuch.enable = true;
      offlineimap = {
        enable = true;
        # postSyncHookCommand = ;
        extraConfig = ''
          # alot per-account extraConfig
          # The startdate option expects a date in the format yyyy-mm-dd.
          # can't be used with maxage
          # startdate = 2018-04-01
          '';

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

    # iij = {
    #   notmuch.enable = true;
    #   userName = "coudron@iij.ad.jp";
    #   realName = "Matthieu Coudron";
    #   address = "test@testjj.ad.jp";
    #   passwordCommand = "";
    #   imap = { host = "imap-tyo.iiji.jp"; };
    #   smtp = { host = "mbox.iiji.jp"; };
    #   # getLogin = "";
    # };

  };



   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
     # extraConfig = {
     #   maildir = {
     #   };
     # };
   };

   programs.msmtp = {
     enable = true;
     extraConfig = ''
     '';
   };

   programs.alot = {
     enable = true;

     # sendCommand = config.programs.msmtp.sendCommand;
     # mta type
     # contactCompletionCommand
     # createAliases=true;
     # generate alias
     # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
     # w = pipeto urlscan 2> /dev/null

     # initial_command = bufferlist; taglist; search foo; search bar; buffer 0
     #  mailinglists = lisp@ietf.org, taps@ietf.org 
     # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
     bindings = {
        global = {
          R = "reload";
          "/" = "prompt search ";
        };
        thread = {
          a = "call hooks.apply_patch(ui)";
          "' '" = "fold; untag unread; move next unfolded";
        };
      };

# editor_command
# editor_spawn
# attachment_prefix = ~/Downloads
        # theme = "solarized";
     extraConfig = ''
        editor_in_thread = True
        auto_remove_unread = True
        ask_subject = False
        handle_mouse = True
     '';

# TODO add as a string  extraConfigStr
# [tags]
#   [[inbox]]
#     translated = 📥
#   [[unread]]
#     translated = ✉
#   [[replied]]
#     translated = ⏎
#   [[sent]]
#     translated = ↗
#   [[attachment]]
#     translated = 📎
#   [[lists]]
#     translated = 📃
#   [[bug]]
#     translated = 🐜
#     normal = "", "", "dark red", "", "light red", ""
#   [[encrypted]]
#     translated = 🔒
#   [[spam]]
# translated = ♻
   };


   # disabled for now, use mbsync instead
   programs.offlineimap = {
     enable = true;
   #   # postSyncHook=''
   #   #  notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc new
   #   #   '';

     extraConfig = ''
# interval between updates (in minutes)
autorefresh=0

[DEFAULT]
# in bytes
# The startdate option expects a date in the format yyyy-mm-dd.
# can't be used with maxage
# startdate = 2018-04-01
maxsize=2000000
# works only with local folders of type maildir in daysA
# maxage=30
synclabels= yes
'';

  # pythonFile = ''
# import subprocess
# import keyring

# def get_pass (service, name):
    # v = keyring.get_password(service, name)
    # return v
    # '';
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
