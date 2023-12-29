final: prev:

rec {
  python3 = prev.python3.override {
    # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {

      protobuf = pythonsuper.protobuf.override {
        inherit (final.onnxruntime) protobuf;
      };

      kergen = prev.callPackage ./pkgs/kergen.nix { };

      mininet-with-man = pythonsuper.mininet.override ({
        withManpage = true;
      });

      # because of https://github.com/pazz/alot/issues/1512
      # tuple('='.join(p) for p in part.get_params())
      # alot = pythonsuper.alot.overrideAttrs (oa: {
      #   name = "alot-dev";
      #   version = "0.9-dev";
      #   src = builtins.fetchGit {
      #     url = https://github.com/pazz/alot.git;
      #     rev = "7915ea60ba866010abc728851626df96d8b80816";
      #   };
      #   buildInputs = oa.buildInputs ++ [ pythonself.notmuch2 ];
      #   # src = super.fetchFromGitHub {
      #   #   owner = "pazz";
      #   #   repo = "alot";
      #   #   rev = "6bb18fa97c78b3cb1fcb60ce5d850602b55e358f";
      #   #   sha256 = "1l8b32ly0fvzwsy3f3ywwi0plckm31y269xxckmgi02sdwisq1ah";
      #   # };
      # });

    };
  };

  python3Packages = python3.pkgs;

}
