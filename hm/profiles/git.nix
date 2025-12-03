{
  config,
  pkgs,
  lib,
  # secrets, # for email
  ...
}:
{

  # for aws-vault ?
  home.file.".ssh/allowed_signers".text = "* ${builtins.readFile ../../perso/keys/id_rsa.pub}";

  programs.delta.enable = true;

  programs.git = {
    enable = true;

    package = pkgs.gitFull; # to get send-email

    includes = [
      # { path = config.xdg.configHome + "/git/config.inc"; }
      # everything under ~/yourworkfolder/ is company code, so use the other user/email/gpg key, etc
    ];
    # https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

    # lots inspired by https://blog.gitbutler.com/how-git-core-devs-configure-git/
    settings = {
      user = {
        # mkForce due to nova
        name = "Matthieu C.";
        email = lib.mkForce "886074+teto@users.noreply.github.com";
      };
      alias = {
        s = "status";
        st = "status";
        br = "branch";
        d = "diff";
        mg = "mergetool";

        # get top level directory of the repo
        root = "git rev-parse --show-toplevel";
      };

      # breaks jkops
      branch = {
        sort = "-committerdate";
      };
      clone.defaultRemoteName = "up";
      init.defaultBranch = "main";
      # git config core.sshCommand "ssh -vvv"
      # useful when merging from kernel
      checkout = {
        defaultRemote = "upstream";
      };

      # https://git-scm.com/book/en/v2/Git-Tools-Credential-StoragE
      credential.helper = "store";

      # show the full diff under the commit message
      commit = {
        status = true;
        verbose = true;
        # template = "filename";
      };
      core = {
        # sshCommand = "ssh -vvv";
        sshCommand = "ssh";

        # might be broken/use too many fds ?
        # fsmonitor = "${pkgs.rs-git-fsmonitor}/bin/rs-git-fsmonitor";
        # untrackedCache ?
      };

      rebase = {
        autosquash = true;
        autoStash = true;
        # takes stacked refs in a branch and makes sure they're also moved when a branch is rebased.
        updateRefs = true;
      };

      pull = {
        rebase = true;
        # ff = "only";
      };

      stash = {
        showPatch = 1;
      };

      column = {
        # nodense
        ui = "always";
      };

      color = {
        ui = true;
      };
      # vimdiff as merge and diff tool
      merge = lib.mkForce {
        tool = "fugitive";
        conflictstyle = "zdiff3";
      };

      mergetool = {
        keepBackup = false;
        vimdiff = {
          prompt = true;
          cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        };
        fugitive = {
          cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
        };
      };

      # TODO use a fully qualified nvim ?
      diff = {
        algorithm = "histogram";
        tool = "nvim -d";
        # word-diff = "color";
        renamelimit = 14000; # useful for kernel
        # how code movement in different colors then added and removed lines.
        colorMoved = true;

        # replace the a/ and b/ in your diff header output with where the diff is coming from, so i/ (index), w/ (working directory) or c/ commit.
        mnemonicPrefix = true;

      };

      tag = {
        sort = "version:refname";
      };

      # pager = {
      #   # diff-so-fancy | less --tabs=1,5 -RFX
      #   diff = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      #   show = "${pkgs.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      # };
    };
  };
}
