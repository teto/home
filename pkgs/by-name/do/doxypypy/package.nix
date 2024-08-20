{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "doxypypy";
  version = "0.8.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "YnVxRVxTfrkdaZjZWzLvw8U1YrLbra/LF+SVk+Da4Bs=";
  };

  meta = with stdenv.lib; {
    description = "a Doxygen filter for Python";
    homepage = https://github.com/Feneric/doxypypy;
    license = licenses.gpl2;
  };

}
