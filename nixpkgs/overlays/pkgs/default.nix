final: prev:
{
  # upstreamed already
  # myHelm = final.wrapHelm final.kubernetes-helm {
  #   plugins = with final.kubernetes-helmPlugins; [ helm-s3 helm-secrets helm-diff ];
  # };
  buku_run = prev.stdenv.mkDerivation rec {
    pname = "buku_run";
    version = "0.1.1";

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

  # qtgo = prev.callPackage ./qtgo {};

  menutray = prev.callPackage ./menutray {};

  colr = prev.callPackage ./colr {};

  dualsub = prev.callPackage ./dualsubtitles { };

  # mda-lite = prev.pythonPackages.callPackage ./mda-lite {};

  mptcpnumerics = prev.python3Packages.callPackage ./mptcpnumerics.nix {};

  # install from the repo
  # neovim-gtk = prev.callPackage ./neovim-gtk { };

  subtitles-rs = prev.callPackage ./subtitles-rs { };

  # rustNightlyPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform rust-nightly);
  # rt-tests = prev.callPackage ./rt-test.nix {};

  i3dispatch = prev.python3Packages.callPackage ./i3-dispatch { inherit (prev) lib;};

  # i3-snapshot = prev.callPackage ./i3-snapshot {};
  # rofi-scripts = prev.callPackage ./rofi-scripts {};

  # neovide = prev.callPackage ./neovide { neovide = prev.neovide; };
  # neovide = prev.callPackage ./neovide { neovide = prev.neovide; };
}
