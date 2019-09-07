 # If the path is a directory, then we take the content of the directory, order it lexicographically, and attempt to interpret each as an overlay by:

 #    Importing the file, if it is a .nix file.

 #    Importing a top-level default.nix file, if it is a directory. 
final: prev:
{
  # astroid = prev.astroid;
  # astroid = prev.enableDebugging prev.astroid;

  # ebpfdropper = prev.callPackage ./ebpfdropper.nix {
  #   stdenv=prev.clangStdenv;
  #   llvm=prev.llvm_5;
  # };
  buku_run = prev.stdenv.mkDerivation rec {
    pname = "buku_run";
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


  colr = prev.callPackage ./colr {};

  dig = final.bind.dnsutils;

  dualsub = prev.callPackage ./dualsubtitles { };

  fzf-extras =  # prev.callPackage ./fzf-extras.nix {};
    builtins.fetchurl https://github.com/atweiden/fzf-extras/blob/master/fzf-extras.zsh;

  gitbatch = prev.callPackage ./gitbatch { };

  gnvim = prev.callPackage ./gnvim { };

  hunter = prev.callPackage ./hunter { };

  mda-lite = prev.pythonPackages.callPackage ./mda-lite {};

  mptcpnumerics = prev.python3Packages.callPackage ./mptcpnumerics.nix {};

  mptcpanalyzer = prev.python3Packages.callPackage ./mptcpanalyzer { };

  neovim-gtk = prev.callPackage ./neovim-gtk { };

  nushell = prev.callPackage ./nushell { };

  # nix-dev = prev.nix.overrideAttrs(oa: {
  #   dontStrip = true;
  #  enableDebugging = true;
  # }

  subtitles-rs = prev.callPackage ./subtitles-rs { };


  # http-getter = prev.python3Packages.callPackage ./http-getter { } ;
  packetdrill-mptcp = prev.packetdrill.overrideAttrs ( oa: {
  });


  # oni = prev.callPackage ./oni/default.nix {};


  # rustNightlyPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform rust-nightly);

  # nix-lsp = prev.callPackage ./nix-lsp {
  #   inherit rustNightlyPlatform;
  # };

  papis-python-rofi = prev.python3Packages.callPackage ./papis-rofi.nix {};

  ping = prev.prettyping;

  rt-tests = prev.callPackage ./rt-test.nix {};

  termite-color-switcher = prev.callPackage ./termite-color-switcher {};

  # netbee = prev.callPackage ./netbee {};

  mptcptrace = prev.callPackage ./mptcptrace {};

  mptcpplot = prev.callPackage ./mptcpplot {};

  stab = prev.callPackage ./stab.nix {
    inherit (prev.pkgs.gnome2) libgnome libgnomeui;
  };

  i3dispatch = prev.python3Packages.callPackage ./i3-dispatch {};

  rofi-scripts = prev.callPackage ./rofi-scripts {};

  texlab = prev.callPackage ./texlab {};


}
