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
        # cmd2 = pythonsuper.cmd2.overrideAttrs (oa: {
        #   # installFlags = [ "--ignore-installed" ];
        #   version = "1.0";
        #   nativeBuildInputs = oa.nativeBuildInputs ++ [ super.git ];
        #   src = /home/teto/cmd2;
        #   # src = super.fetchgit {
        #   #   url=https://github.com/python-cmd2/cmd2.git;
        #   #   rev = "f38e100fd77f4a136a4883d23b2f4f8b3cd934b7";
        #   #   sha256 = "0nc15i1628y66030d0b2g3xriyhxps5v8s9y1d6kx8jp1ccwvyfz";
        #   #   leaveDotGit = true;
        #   #   deepClone = true;
        #   # };
        #   doCheck = false;
        # });

        # praw = pythonsuper.praw.overrideAttrs (oldAttrs: {
        #   doCheck = false;
        # });


        pelican = pythonsuper.pelican.overrideAttrs (oldAttrs: {
          # src=fetchGitHashless {
          #   url=file:///home/teto/pygccxml;
          # };
          propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ pythonself.markdown];
        });

        pandas = pythonsuper.pandas.overridePythonAttrs (oa: {

          src = super.fetchFromGitHub {
            owner = "teto";
            repo = "pandas";
            rev = "5d3e6912a15a83a39d5e854fa2a67da14e7ea8af";
            sha256 = "0szkhmsndy3spvf5vg7mil68bnf5xg9pdzk75y9n8fhslj0v0j4v";
          };

          # src = super.fetchFromGitHub {
          #   owner = "pandas-dev";
          #   repo = "pandas";
          #   rev = "9c0f6a8d703b6bee48918f2c5d16418a7ff736e3";
          #   sha256 = "0czdfn82sp2mnw46n90xkfvfk7r0zgfyhfk0npnglp1jpfndpj3i";
          # };

          doCheck = false;
          installCheckPhase = false;
        });
    };
  };

  python3Packages = python3.pkgs;
}

