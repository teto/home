{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Python with venv support
    python3
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.virtualenv

    # System dependencies
    mpv  # Required for python-mpv bindings

    # Optional: GUI dependencies (for extras)
    gobject-introspection
    gtk3
    libnotify

    # Build tools
    gcc
    pkg-config
  ];

  shellHook = ''
    # Set up environment for python-mpv to find libmpv
    export LD_LIBRARY_PATH="${pkgs.mpv}/lib:$LD_LIBRARY_PATH"

    # Make sure pip can compile packages if needed
    export PKG_CONFIG_PATH="${pkgs.mpv}/lib/pkgconfig:$PKG_CONFIG_PATH"

    echo "Nix development environment loaded!"
    echo ""
    echo "To create and activate a venv:"
    echo "  python -m venv venv"
    echo "  source venv/bin/activate"
    echo ""
    echo "To install in development mode:"
    echo "  pip install -e ."
    echo ""
    echo "To install with all extras:"
    echo "  pip install -e .[all]"
  '';
}
