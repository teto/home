{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "doxypypy";
  version = "0.8.8.6";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "YnVxRVxTfrkdaZjZWzLvw8U1YrLbra/LF+SVk+Da4Bs=";
  };

  meta = with lib; {
    description = "a Doxygen filter for Python";
    homepage = "https://github.com/Feneric/doxypypy";
    license = licenses.gpl2;
  };

}
