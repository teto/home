{stdenv, rofi,gawk,fetchFromGitHub , gnused,buku,bash}:
  stdenv.mkDerivation {
    pname = "buku_run";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "teto";
      repo = "buku_run";
      rev = "50aac85f8e42618cfd636f5040ba690a7e365d6f";
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

    buildInputs = [ rofi gawk gnused buku bash ];
    # propagatedBuildInputs = [ rofi ];

  }
