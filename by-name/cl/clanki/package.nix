{
  lib,
  python3Packages,
  fetchFromGitHub,
  anki ? null,
}:

python3Packages.buildPythonPackage rec {
  pname = "clanki";
  version = "0.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "alvenw";
    repo = "clanki";
    rev = "15c9847a05a4a6db25d4abc1e99a7da3dacb073b";
    sha256 = "sha256-QnG5kOOKFwV8KMVwGjrrsf7hJXzTmrc/gw14vGKExEI=";
  };

  propagatedBuildInputs = with python3Packages; [
    anki
    textual
    textual-image
  ];

  # Override to resolve typing_extensions conflict by disabling the check
  dontUsePythonCatchConflicts = true;
  # pythonCatchConflictsPhase = ''
  #   # Skip the typing_extensions conflict check
  #   true
  # '';

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  # IMPORTANT: Clanki requires the Anki desktop application to be installed
  # and its Python libraries to be available in PYTHONPATH at runtime.
  # The Nix package builds successfully but will not work without the Anki Python
  # library being available. Users need to set PYTHONPATH to include Anki's
  # Python library path, typically something like:
  #   export PYTHONPATH="$(nix-build '<nixpkgs>' -A anki --no-out-link)/lib/python*/site-packages:$PYTHONPATH"
  # See the shell.nix for a complete development environment setup.

  # Disable runtime dependency check since anki is not available as a Python package
  # but is provided by the anki desktop application
  dontCheckRuntimeDeps = true;

  doCheck = false;

  meta = with lib; {
    description = "Terminal-based Anki review client using native Anki backend";
    homepage = "https://github.com/alvenw/clanki";
    license = licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ maintainers.teto ];
  };
}
