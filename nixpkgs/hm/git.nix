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
    delta.enable = true;
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

      pager = {
        # diff-so-fancy | less --tabs=1,5 -RFX
        diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
        show = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      };
    };
  };
}

