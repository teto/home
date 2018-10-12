 # If the path is a directory, then we take the content of the directory, order it lexicographically, and attempt to interpret each as an overlay by:

 #    Importing the file, if it is a .nix file.

 #    Importing a top-level default.nix file, if it is a directory. 
final: prev:
{
  # imports = [
  #   # ./modules/services/gnome3.nix
  #   ./kernels.nix
  # ];
  # vdirsyncer = prev.vdirsyncer.overrideAttrs ( oa: {
  #   src = fetchGit {
      # url = https://github.com/pimutils/vdirsyncer.git;
    # };
  # });

  # astroid = prev.astroid;
  # astroid = prev.enableDebugging prev.astroid;

  # ebpfdropper = prev.callPackage ./ebpfdropper.nix {
  #   stdenv=prev.clangStdenv;
  #   llvm=prev.llvm_5;
  # };


  dualsub = prev.callPackage ./dualsubtitles { };

  # subtitles-rs = prev.subtitles-rs or (prev.callPackage ./subtitles-rs { });

  buku_run = prev.stdenv.mkDerivation rec {
    name = "buku_run-${version}";
    version = "0.1.1";

    # src = /home/teto/buku_run;

    src = prev.fetchFromGitHub {
      owner = "teto";
      repo = "buku_run";
      rev =  "50aac85f8e42618cfd636f5040ba690a7e365d6f";
      sha256 = "1r90zpg5m717rnj29lngd6sqdq5214y0v96b7f05xh42ysbdr2gd";
    };
    
    # src = prev.fetchFromGitHub {
    #   owner = "carnager";
    #   repo = "buku_run";
    #   rev =  version;
    #   sha256 = "1zyjjf3b8g3dnymcrg683rbnc6qrvx8ravfm833n7kjrqky3bczn";
    # };
    
    buildPhase = ":";

    postUnpack = ''
      patchShebangs .
    '';

    installFlags = [ "PREFIX=$(out)" ];

    buildInputs = with prev.pkgs; [ rofi gawk gnused buku bash ];
    # propagatedBuildInputs = [ rofi ];

  };

  mptcpanalyzer = prev.python3Packages.callPackage ./mptcpanalyzer {
    # tshark = self.pkgs.tshark-reinject-stable; 
    # inherit (prev.pkgs) tshark;
    tshark = final.pkgs.tshark-dev-stable;
  };

  # http-getter = prev.python3Packages.callPackage ./http-getter { } ;

  oni = prev.callPackage ./oni/default.nix {};

  mptcpnumerics = prev.python3Packages.callPackage ./mptcpnumerics.nix {};

  rt-tests = prev.callPackage ./rt-test.nix {};

  netbee = prev.callPackage ./netbee {};

  # gImageReader = prev.gImageReader or prev.libsForQt5.callPackage ./gImageReader {
  #   # must be python3
  #     python = prev.python3;
  # };

  mptcptrace = prev.callPackage ./mptcptrace {};

  stab = prev.callPackage ./stab.nix {
    inherit (prev.pkgs.gnome2) libgnome libgnomeui;
  };

  i3dispatch = prev.python3Packages.callPackage ./i3-dispatch {};
  # linux_mptcp_4_94 = prev.callPackage ./mptcp {};
}
