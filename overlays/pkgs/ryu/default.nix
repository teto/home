{ stdenv, buildPythonPackage, fetchFromGitHub }:
buildPythonPackage rec {
  pname = "ryu";
  version = "4.33";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "ryu";
    rev = "v${version}";
    sha256 = "0dzdak69ss56n68qssxi9fi9b55y36wj3xiph5y7dw7dbjqax9fi";
  };

  doCheck = false;

  meta = with lib; {
    description = "Component-based software defined networking framework";
    homepage = https://github.com/nichoski/kergen;
    maintainers = with maintainers; [ teto ];
    license = licenses.asl20;
  };
}
