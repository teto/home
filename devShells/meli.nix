{ pkgs, lib, ... }:

# avante now has a flake
pkgs.mkShell {
  name = "meli";
  buildInputs = with pkgs; [
    cargo
    rustc
    gnum4
    gcc
    # missing 'ruststylecheck'
    pkg-config
    openssl
    perl
  ];

  shellHook = with pkgs; ''
      export LD_LIBRARY_PATH=${
        lib.makeLibraryPath [
          gpgme
          notmuch
        ]
      }

    echo "Welcome to the meli development environment!"
    export PATH="${lib.makeBinPath [ gnum4 ]}:$PATH"
  '';
}
