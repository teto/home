{ pkgs, lib, ... }:

# avante now has a flake
pkgs.mkShell {
  name = "meli";
  buildInputs = with pkgs; [
    gnum4
    gcc
    # missing 'ruststylecheck'
  ];

  shellHook = with pkgs; ''
      export LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          gpgme
          notmuch
        ]
      }

    echo "Welcome to the meli development environment!"
  '';
}
