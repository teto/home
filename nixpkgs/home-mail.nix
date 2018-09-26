{ pkgs, lib, config, ... }:
let 
  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';
    extraConfig.channel = {
      MaxMessages = 1000;
      # size[k|m][b]
      MaxSize = "1m";
    };
    # postSyncHookCommand = "notmuch new";
    create = "maildir";
  };

  accountExtra = {
    astroid = {
      enable = true;
    };
  };


  mbsyncWrapper = pkgs.writeShellScriptBin "mbsync" ''
      ${pkgs.isync}/bin/mbsync $@
      notmuch new
    '';

  # temporary solution since it's not portable
  getPassword = account:
    "/home/teto/dotfiles/bin/pass-show ${account}";

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
    signByDefault = true;
  };
in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    gmail = accountExtra // {
    # gmail = {
      gpg = gpgModule;
      # astroid = {
      #   enable = true;
      # };

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

      # TODO this should be made default
      # maildirModule.path = "gmail";

      # keyring get gmail login
      # loginCommand = 
      # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";
      passwordCommand = getPassword "gmail";

      # contactCompletion = "notmuch address";
    }; 

    iij = accountExtra // {
      mbsync = mbsyncConfig;
      alot = { enable = true; };
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
      # passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup iij password";

      passwordCommand = getPassword "iij/mail";
      imap = { host = "imap-tyo.iiji.jp"; tls = my_tls; };
      smtp = { host = "mbox.iiji.jp"; tls = my_tls; };
    };
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
     '';
   };

   programs.alot = {
     enable = true;

   #   # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
   #   # w = pipeto urlscan 2> /dev/null

   #   # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
     bindings = {
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
          d = "toggletags killed";
        };
        thread = {
          a = "call hooks.apply_patch(ui)";
          "' '" = "fold; untag unread; move next unfolded";

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

      tags = {
        replied = {
          translated = "⏎";
        };
      };
     extraConfig.structured = {
      # editor_command
      # editor_spawn
      # attachment_prefix = ~/Downloads
        # theme = "solarized";
       # foireux comme option
       # convertir
       # on a per account ?
      #  mailinglists = lisp@ietf.org, taps@ietf.org 
        editor_in_thread = false;
        auto_remove_unread = true;
        ask_subject = false;
        handle_mouse = true;
      # terminal_cmd
      # taglist_statusbar
        thread_authors_replace_me = true;
        # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
      };

      extraConfig.text = ''

        '';

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
   };


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

  programs.astroid = {
    enable = true;
    #
    # offlineimap || exit $?
    # 
    # notmuch new || exit $?
    # polling = {
    # };
    pollScript = ''
      mbsync gmail
    '';

    # I don't want it to trigger
    # P => main_window.poll
    extraConfig = {
      poll.interval = 0;
    };

    externalEditor = ''
      termite -e "nvim -c 'set ft=mail' '+set fileencoding=utf-8' '+set ff=unix' '+set enc=utf-8' '+set fo+=w' %1"
    '';
  };

}
