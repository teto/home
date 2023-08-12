{ config, pkgs, lib, ... } @ args:
let
  secrets = import ../../nixpkgs/secrets.nix;
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull; # to get send-email
    delta.enable = true;
    includes = [
      { path = config.xdg.configHome + "/git/config.inc"; }
      # everything under ~/yourworkfolder/ is company code, so use the other user/email/gpg key, etc
      {
        # path = ./resources/gitconfigwork;
        path = config.xdg.configHome + "/git/config.inc";
        condition = "gitdir:~/nova/";
      }
    ];
    # https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work

    aliases = {
      s = "status";
      st = "status";
      br = "branch";
      d = "diff";
      mg = "mergetool";

    };
    extraConfig = {
      # breaks jkops
      clone.defaultRemoteName = "up";
      init.defaultBranch = "main";
      # git config core.sshCommand "ssh -vvv"
      # useful when merging from kernel
      checkout = { defaultRemote = "upstream"; };

      # show the full diff under the commit message
      commit.verbose = true;
      core = {
        # sshCommand = "ssh -vvv";
        sshCommand = "ssh";
      };

      rebase = {
        autosquash = true;
        autoStash = true;
      };

      pull = {
        rebase = true;
        # ff = "only";
      };



      stash = {
        showPatch = 1;
      };
      color = {
        ui = true;
      };
      # vimdiff as merge and diff tool
      merge = {
        tool = "fugitive";
        conflictstyle = "diff3";
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
      # [mergetool "vimdiff"]
      #   prompt = true
      #   cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

      # [mergetool "fugitive"]
      # ; Use :Gdiffsplit! for 3 way diff
      # 	cmd = nvim -f -c \"Gdiffsplit!\" \"$MERGED\"

      # TODO use a fully qualified nvim ?
      diff = {
        # there is now a specific nvim entry ?
        tool = "nvim -d";
        word-diff = "color";
        renamelimit = 14000; # useful for kernel

      };

      # pager = {
      #   # diff-so-fancy | less --tabs=1,5 -RFX
      #   diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      #   show = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      # };
    };
  };
}

