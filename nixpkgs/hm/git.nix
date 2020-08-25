{ config, pkgs, lib,  ... } @ args:
let
  secrets = import ./secrets.nix;
in
{
  programs.git = {
    enable = true;
    # use accounts.email ?
    # load it from secrets ?
    package = pkgs.gitAndTools.gitFull;    # to get send-email
    delta.enable = false;
    userName = "Matthieu Coudron";
    userEmail = "mcoudron@hotmail.com";
	includes = [
	  { path = config.xdg.configHome + "/git/config.inc"; }
	];

    # https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work
    signing = {
      signByDefault = false;
      key = "64BB6787";
    };
    extraConfig = {
# git config core.sshCommand "ssh -vvv"
      # useful when merging from kernel
      checkout = { defaultRemote="upstream"; };

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
        ff = "only";
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
# [mergetool "vimdiff"]
#   prompt = true
#   cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

# [mergetool "fugitive"]
# ; Use :Gdiffsplit! for 3 way diff
# 	cmd = nvim -f -c \"Gdiffsplit!\" \"$MERGED\"

# [mergetool]
# 	keepBackup = false

      };
      # TODO use a fully qualified nvim ?
      diff = {
        tool = "nvim -d";
        word-diff="color";
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

