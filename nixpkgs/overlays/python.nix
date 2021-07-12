final: prev:

rec {
  python3 = prev.python3.override {
     # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {

        kergen = prev.callPackage ./pkgs/kergen.nix { };

        mininet-matt = pythonsuper.mininet.override ({

          withManpage = true;
        });

        # because of https://github.com/pazz/alot/issues/1512
        # tuple('='.join(p) for p in part.get_params())
        alot = pythonsuper.alot.overrideAttrs (oa: {
          name = "alot-dev";
          version = "0.9-dev";
          src = builtins.fetchGit {
            url = https://github.com/pazz/alot.git;
            rev = "7915ea60ba866010abc728851626df96d8b80816";
          };
          buildInputs = oa.buildInputs ++ [ pythonself.notmuch2 ];
          # src = super.fetchFromGitHub {
          #   owner = "pazz";
          #   repo = "alot";
          #   rev = "6bb18fa97c78b3cb1fcb60ce5d850602b55e358f";
          #   sha256 = "1l8b32ly0fvzwsy3f3ywwi0plckm31y269xxckmgi02sdwisq1ah";
          # };
        });

        papis-dev = pythonsuper.papis.overridePythonAttrs (oa: {
          version = "1.0-dev";
          propagatedBuildInputs = with prev.python3Packages; oa.propagatedBuildInputs ++  ([
            # useful for zotero script
            pyyaml dateutil python-doi
          ]);
          doCheck = false;

          # src = super.fetchFromGitHub {
          #   owner = "papis";
          #   repo = "papis";
          #   rev = "101e83a7014e2ed7d17ceb009a433881354fa0fc";
          #   sha256 = "0hw8f62qri62lg1wi37n0nvw1dw6pcmrbs66zbrzwf54rpl33462";
          #   # fetchSubmodules = true;
          # };
        });
    };
  };

  python3Packages = python3.pkgs;
}
