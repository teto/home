
super.pkgs.stdenv.mkDerivation {
    name = "notmuch-extract-patch";
    src = super.fetchFromGitHub {
      owner = "aaptel";
      repo = "notmuch-extract-patch";
      rev = "f6b282d91af581178150e36369e7fe03a9c813d4";
      sha256="0b8gzyv3lp9qxy2z94ncmh2k8yzwl91ws3m7v2cp232fyx6s7wp7";
    };
    buildInputs = [
      super.pkgs.notmuch
      (super.pkgs.python36.withPackages (pythonPackages: with pythonPackages; [
      ]))
    ];
    # unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp ./notmuch-extract-patch $out/bin/
      # TODO eventually patchShebang
    '';
  }
