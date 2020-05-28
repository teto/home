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

    # packageOverrides = pkgs: {
    #   # fetchGit ?
    #   nur = import (builtins.fetchTarball {
    #     url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    #     # url = "https://github.com/nix-community/NUR/archive/cb0033ca5ef1e2db7952919f0f983ce57d8526b0.tar.gz";
    #     # sha256 = "1yx5g2q0sashbpr2qcqgrgkjsn5440idka1hsppp9a1bwiz35vli";
    #   }) {
    #     inherit pkgs;
    #   };
    # };


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
