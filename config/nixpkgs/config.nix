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

    # internetEnv = pkgs.buildEnv {
    #   name = "internet";
    #   paths = [
    #     # qutebrowser
    #     # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
    #     # mairix mutt msmtp lbdb contacts spamassassin
    #   ];
    # };
}
