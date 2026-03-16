{
  lib,
  python3Packages,
  fetchFromGitHub,
  anki ? null,
  flakeSelf,
}:

python3Packages.buildPythonPackage {
  pname = "clanki";
  version = "0.1.0";
  format = "pyproject";

  # flakeSelf feature/deck-filtering
  src = fetchFromGitHub {
    owner = "alvenw";
    repo = "clanki";
    rev = "86d428e7a28c77d0971e18872605e4a373da676e";
    sha256 = "sha256-5BQXyVO4Y1RnEeyK/MQzIswGQQcU3EMnjyHMSSHIOnY=";
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
