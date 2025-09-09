final: prev:

rec {
  python3 = prev.python3.override {
    # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {

      kergen = prev.callPackage ./pkgs/kergen.nix { };

      mininet-with-man = pythonsuper.mininet.override ({ withManpage = true; });

    };
  };

  python3Packages = python3.pkgs;

}
