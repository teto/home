{ stdenv, pkgs, fetchPypi, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pygccxml";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x1p62ff7ggb172rjr6sbdrjh1gl3ck3bwxsqlsix8i5wycwvnmv";
  };

  propagatedBuildInputs = [ pkgs.castxml ];
  # buildInputs = [ setuptools_scm pytest pkgs.glibcLocales ];

  checkPhase = ''
    # py.test
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/gccxml/pygccxml;
    description = "Python package for easy C++ declarations navigation";
    license = licenses.boost;
    maintainers = with maintainers; [ teto ];
  };
}

