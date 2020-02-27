with import <nixpkgs> {};

luaPackages.argparse.overrideAttrs (oa: {
    doCheck = true;

     # self.busted #
    checkInputs = [];

    # checkPhase = ''
      # busted spec/
    # '';
    shellHook = ''
      export PATH="/home/teto/busted/bin:$PATH"
    '';
})
