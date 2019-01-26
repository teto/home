{ stdenv, buildPythonPackage, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "kergen";
  version = "10.36.0";

  src = fetchFromGitHub {
    owner = "ulfalizer";
    repo = "Kconfiglib";
    rev = "v${version}";
    sha256 = "0dzdak70ss56n68qssxi9fi9b55y36wj3xiph5y7dw7dbjqax9fi";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A flexible Python 2/3 Kconfig implementation and library";
    homepage = https://github.com/nichoski/kergen;
    maintainers = with maintainers; [ teto ];
    # license = 
  };
}


