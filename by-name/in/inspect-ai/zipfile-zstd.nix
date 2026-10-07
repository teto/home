{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zstandard,
}:
buildPythonPackage rec {
  pname = "zipfile-zstd";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wUmOFbeSKj0a8OpV34sRsq9Oj34OgOQU4l1miZ9974k=";
  };

  build-system = [ setuptools ];
  dependencies = [ zstandard ];
  pythonImportsCheck = [ "zipfile_zstd" ];

  meta = {
    description = "Zstandard compression support for Python's zipfile module";
    homepage = "https://github.com/taisei-project/python-zipfile-zstd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
  };
}
