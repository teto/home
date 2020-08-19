  let
    # baseCommit = "..."; # Pick a Nixpkgs version to pin to.
    # baseSha = "..."; # The SHA of the above version.

    # Pick a static-haskell-nix version to pin to.
    # trop vieux
    # staticHaskellNixCommit = "8e73cdc0bebb58577978f319a5c3c8a3b0da98f4";
    staticHaskellNixCommit = "dbce18f4808d27f6a51ce31585078b49c86bd2b5";

    # baseNixpkgs = ./nixpkgs.nix;
    # baseNixpkgs = builtins.fetchTarball {
    #   name = "nixos-nixpkgs";
    #   url = "https://github.com/NixOS/nixpkgs/archive/${baseCommit}.tar.gz";
    #   sha256 = baseSha;
    # };

    staticHaskellNixpkgs = builtins.fetchTarball
      "https://github.com/nh2/static-haskell-nix/archive/${staticHaskellNixCommit}.tar.gz";

    # The `static-haskell-nix` repository contains several entry points for e.g.
    # setting up a project in which Nix is used solely as the build/package
    # management tool. We are only interested in the set of packages that underpin
    # these entry points, which are exposed in the `survey` directory's
    # `approachPkgs` property.
    staticHaskellPkgs = (
      import (staticHaskellNixpkgs + "/survey/default.nix") {
        tracing = true;
        compiler = "ghc883";

      }
    ).approachPkgs;
    overlay = self: super: {
      staticHaskell = staticHaskellPkgs.extend (selfSH: superSH: {
        ghc = (superSH.ghc.override {
          enableRelocatedStaticLibs = true;
          enableShared = false;
        }).overrideAttrs (oldAttrs: {
          preConfigure = ''
            ${oldAttrs.preConfigure or ""}
            echo "GhcLibHcOpts += -fPIC -fexternal-dynamic-refs" >> mk/build.mk
            echo "GhcRtsHcOpts += -fPIC -fexternal-dynamic-refs" >> mk/build.mk
          '';
        });
      });
    };

in
  overlay
