{ stdenv, buildPythonPackage, fetchFromGitHub, rofi, papis, python-rofi
, fetchPypi, lib }:
buildPythonPackage rec {
  pname = "papis-python-rofi";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13k6mw2nq923zazs77hpmh2s96v6zv13g7p89510qqkvp6fiml1v";
  };
  # src = fetchFromGitHub {
  #   owner = "papis";
  #   repo = "papis-rofi";
  #   rev = version;
  #   sha256 = "0iy6r29ncpca7v4ibnig2mh93nkrqvy4nhmzkq6flxmryghfzhwn";
  # };

  buildInputs = [ rofi papis python-rofi ];

  doCheck = false;

  meta = with lib; {
    description = "Linux kernel config generator";
    homepage = https://github.com/nichoski/kergen;
    maintainers = with maintainers; [ teto ];
    license =  licenses.asl20;
  };
}



