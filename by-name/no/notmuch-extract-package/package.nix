{
  notmuch,
  python3,
  fetchFromGitHub,
}:
# super.pkgs.stdenv.mkDerivation
python3.pkgs.buildPythonApplication {
  name = "notmuch-extract-patch";
  src = fetchFromGitHub {
    owner = "aaptel";
    repo = "notmuch-extract-patch";
    rev = "f6b282d91af581178150e36369e7fe03a9c813d4";
    sha256 = "0b8gzyv3lp9qxy2z94ncmh2k8yzwl91ws3m7v2cp232fyx6s7wp7";
  };
  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];
  buildInputs = [ notmuch ];
  # unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ./notmuch-extract-patch $out/bin/
    # TODO eventually patchShebang
    # patchShebang $
  '';
}
