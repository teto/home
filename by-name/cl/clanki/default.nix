{
  pkgs ? import <nixpkgs> { },
}:

let
  clanki = pkgs.callPackage ./package.nix { };
  anki = pkgs.anki;

  # Create a wrapper script that sets up the environment properly
  clanki-wrapper = pkgs.writeShellScriptBin "clanki-wrapper" ''
    #!${pkgs.bash}/bin/bash

    # Try to find the anki Python library
    ANKI_PYTHON_LIB="${pkgs.anki}/lib/python*/site-packages"

    # Set PYTHONPATH to include anki's Python library if it exists
    if [ -d "$ANKI_PYTHON_LIB" ]; then
      export PYTHONPATH="$ANKI_PYTHON_LIB:$PYTHONPATH"
      echo "Added anki Python library to PYTHONPATH: $ANKI_PYTHON_LIB"
    else
      echo "Warning: Could not find anki Python library at $ANKI_PYTHON_LIB"
      echo "You may need to install anki separately or set PYTHONPATH manually"
    fi

    # Execute clanki
    exec ${clanki}/bin/clanki "$@"
  '';

in
{
  inherit clanki anki clanki-wrapper;

  devShell = pkgs.mkShell {
    buildInputs = [
      clanki
      anki
      pkgs.python3
      pkgs.python3Packages.textual
      pkgs.python3Packages.textual-image
    ];

    shellHook = ''
      echo "Clanki development environment ready!"
      echo "You can run clanki using: clanki-wrapper"
      echo "Or manually set PYTHONPATH and run: ${clanki}/bin/clanki"
    '';
  };
}
