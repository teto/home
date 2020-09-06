{ stdenv, buildPythonPackage, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "kergen";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "nichoski";
    repo = "kergen";
    rev = "${version}";
    sha256 = "0dzdak70ss56n68qssxi9fi9b55y36wj3xiph5y7dw7dbjqax9fi";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Linux kernel config generator";
    homepage = https://github.com/nichoski/kergen;
    maintainers = with maintainers; [ teto ];
    license =  licenses.asl20;
  };
}


