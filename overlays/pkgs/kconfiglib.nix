{
  stdenv,
  buildPythonPackage,
  lib,
  fetchFromGitHub,
}:
buildPythonPackage rec {
  pname = "Kconfiglib";
  version = "10.36.0";

  src = fetchFromGitHub {
    owner = "ulfalizer";
    repo = "Kconfiglib";
    rev = "v${version}";
    sha256 = "0dzdak70ss56n68qssxi9fi9b55y36wj3xiph5y7dw7dbjqax9fi";
  };

  doCheck = false;

  meta = with lib; {
    description = "A flexible Python 2/3 Kconfig implementation and library";
    homepage = "https://github.com/ulfalizer/Kconfiglib";
    maintainers = with maintainers; [ teto ];
  };
}
