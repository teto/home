{ pkgs }:
{
	permittedInsecurePackages = [
		"webkitgtk-2.4.11" # for astroid
         # "linux-4.13.16"
	];
	allowBroken = true;
	allowUnfree = true;

    # to replicate grahamOfBorgerros
    checkMeta=true;

    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball {
        # url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
        url = "https://github.com/nix-community/NUR/archive/84c7b0826bf0050b3851bef3252724c43f6736a7.tar.gz";
        sha256 = "04386gzgl8y555b3lkz9aiw9xsldfg4zmzp930m62qw8zbrvrshd"; 
      }) {
        inherit pkgs;
      };
    };


    # this proved necessary to call  nix-build -A linux_hardkernel_4_14  ~/nixpkgs3
    allowUnsupportedSystem = true; 


    # internetEnv = pkgs.buildEnv {
    #   name = "internet";
    #   paths = [
    #     # qutebrowser
    #     # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    #     # mairix mutt msmtp lbdb contacts spamassassin
    #   ];
    # };
}
