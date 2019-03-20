self: super:

rec {
  python = super.python.override {
     # Careful, we're using a different self and super here!
    packageOverrides = python-self: pythonsuper: {

        # mininet-python = pythonsuper.mininet-python.overrideAttrs ( oa: {
        #   src = /home/teto/mininet2;
        # });

      # };
    };
  };
  pythonPackages = python.pkgs;

  python3 = super.python3.override {
     # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {

        kergen = pythonsuper.callPackage ./pkgs/kergen.nix { };
        Kconfiglib =  pythonsuper.callPackage ./pkgs/kconfiglib.nix { };
      # if (super.pkgs ? pygccxml) then null else
        # now that s wird
        # pygccxml =  super.callPackage ../pygccxml.nix {
        # pkgs = super.pkgs;
        # pythonPackages = self.pkgs.python3Packages;
        # pygccxml = pythonsuper.pygccxml.overrideAttrs (oldAttrs: {
        #   # src=fetchGitHashless {
        #   #   url=file:///home/teto/pygccxml;
        #   # };

        #   src=/home/teto/pygccxml;
        # });

        # TODO write a nix-shell instead
        # protocol = pythonsuper.protocol.overrideAttrs (oldAttrs: {
        #   src=/home/teto/protocol;
        # });

        alot = pythonsuper.alot.overrideAttrs (oldAttrs: {
          name = "alot-dev";
          version = "0.9-dev";
          src = super.fetchFromGitHub {
            owner = "pazz";
            repo = "alot";
            rev = "6bb18fa97c78b3cb1fcb60ce5d850602b55e358f";
            sha256 = "1l8b32ly0fvzwsy3f3ywwi0plckm31y269xxckmgi02sdwisq1ah";
          };
        });


        # papis = pythonsuper.papis.overrideAttrs (oldAttrs: {
        #   version = "0.8-dev";
        #   src = super.fetchFromGitHub {
        #     owner = "papis";
        #     repo = "papis";
        #     rev = "11e368cf437f90ce4835f486eda8d946c84eb577";
        #     sha256 = "0l8b32ly0fvzwsy3f3ywwi0plckm31y269xxckmgi02sdwisq2ah";
        #   };
        # });

        # look for matching wcwidth
        cmd2 = pythonsuper.cmd2.overrideAttrs (oa: {
          # installFlags = [ "--ignore-installed" ];
          version = "1.0";
          nativeBuildInputs = oa.nativeBuildInputs ++ [ super.git ];
          # src = /home/teto/cmd2;
          src = super.fetchgit {
            url=https://github.com/python-cmd2/cmd2.git;
            rev = "9f5906a5cc1128652f1b43545ae4c948e9a0fe2b";
            sha256 = "12gkdyp2xgdi2a3aan7ifl16mp5dac8z5fhjy3i8yjl1hdsj74qp";
            leaveDotGit = true;
            deepClone = true;
          };
          doCheck = false;
        });

        # praw = pythonsuper.praw.overrideAttrs (oldAttrs: {
        #   doCheck = false;
        # });


        pelican = pythonsuper.pelican.overrideAttrs (oldAttrs: {
          # src=fetchGitHashless {
          #   url=file:///home/teto/pygccxml;
          # };
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ pythonself.markdown];
        });

    };
  };

  python3Packages = python3.pkgs;
}

