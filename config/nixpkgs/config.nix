{ pkgs }:
{
	permittedInsecurePackages = [
         "xpdf-4.02"  # for pdftotext
	];
	allowBroken = true;
	allowUnfree = true;

    # to replicate grahamOfBorgerros
    # genere un probleme avec 
    # checkMeta=true;
    # doCheckByDefault = true;

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
