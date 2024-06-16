let
  nix_src = fetchGit "https://github.com/NixOS/nix";
  nix_release = import (nix_src + "/release.nix") {
    nix = nix_src;
    nixpkgs = <nixpkgs>;
  };
in
nix_release.build.x86_64-linux # // { perl-bindings = nix_release.perlBindings.x86_64-linux; }
