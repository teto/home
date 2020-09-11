self: super:

rec {
  # python = super.python.override {
  #    # Careful, we're using a different self and super here!
  #   packageOverrides = python-self: pythonsuper: {
  #       # mininet-python = pythonsuper.mininet-python.overrideAttrs ( oa: {
  #       #   src = /home/teto/mininet2;
  #       # });
  #     # };
  #   };
  # };
  # pythonPackages = python.pkgs;

  python3 = super.python3.override {
     # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {

        kergen = pythonsuper.callPackage ./pkgs/kergen.nix { };


        # Kconfiglib =  pythonsuper.callPackage ./pkgs/kconfiglib.nix { };

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

        # python-doi = pythonsuper.callPackage ./pkgs/python-doi {};

        # pytest-mock = pythonsuper.pytest-mock.overrideAttrs(oa: {
        #   src = super.fetchFromGitHub {
        #     rev = "189cc599d3bfbe91a17c93211c04237b6c5849b1";
        #     owner = "pytest-dev";
        #     repo = "pytest-mock";
        #     sha256 = "1p33zz11kk5qfwyaqgzwil5p555n29qrcb770rn3pa7cy8ncnxqk";
        #   };
        #   SETUPTOOLS_SCM_PRETEND_VERSION="1.10.5";
        # });

        mininet = pythonsuper.alot.overrideAttrs (oldAttrs: {
        });

        # alot = pythonsuper.alot.overrideAttrs (oldAttrs: {
        #   name = "alot-dev";
        #   version = "0.9-dev";
        #   src = builtins.fetchGit {
        #     url = https://github.com/pazz/alot.git;
        #   };
        #   # src = super.fetchFromGitHub {
        #   #   owner = "pazz";
        #   #   repo = "alot";
        #   #   rev = "6bb18fa97c78b3cb1fcb60ce5d850602b55e358f";
        #   #   sha256 = "1l8b32ly0fvzwsy3f3ywwi0plckm31y269xxckmgi02sdwisq1ah";
        #   # };
        # });

        # this doesn't work, need to use the proper nixpkgs revision
        # poetry = pythonsuper.poetry.overridePythonAttrs(oa: {
        #   src = self.fetchFromGitHub {
        #     owner = "python-poetry";
        #     repo = "poetry";
        #     rev = "1.0.2";
        #     sha256 = "sha256-pqDCCWyoGhkiayy+RMfXlYOD8mbAikBGDvRJnsAUpjw=";
        #   };
        # });

        papis-dev = pythonsuper.papis.overridePythonAttrs (oa: {
          version = "1.0-dev";

          # datautil
          # super.python3Packages.sqlite
          propagatedBuildInputs = with super.python3Packages; oa.propagatedBuildInputs ++  ([
            # useful for zotero script
            pyyaml dateutil python-doi
          ]);
          # src = /home/teto/papis;
          doCheck = false;

          # src = builtins.fetchGit {
          #   url = https://github.com/teto/papis;
          #   ref = "zsh_completion";
          #   # rev = "101e83a7014e2ed7d17ceb009a433881354fa0fc";
          #   # sha256 = "0hw8f62qri62lg1wi37n0nvw1dw6pcmrbs66zbrzwf54rpl33462";
          #   # fetchSubmodules = true;
          # };

          # src = super.fetchFromGitHub {
          #   owner = "papis";
          #   repo = "papis";
          #   rev = "101e83a7014e2ed7d17ceb009a433881354fa0fc";
          #   sha256 = "0hw8f62qri62lg1wi37n0nvw1dw6pcmrbs66zbrzwf54rpl33462";
          #   # fetchSubmodules = true;
          # };
        });


        pycurl = pythonsuper.pycurl.overrideAttrs (oa: {
          doCheck = false;
          installCheckPhase = false;
        });

        # pymupdf = pythonsuper.callPackage ./pkgs/pymupdf { };

        # look for matching wcwidth
        # cmd2 = pythonsuper.cmd2.overrideAttrs (oa: {
        #   # installFlags = [ "--ignore-installed" ];
        #   version = "1.0";
        #   nativeBuildInputs = oa.nativeBuildInputs ++ [ super.git ];
        #   # src = /home/teto/cmd2;
        #   src = super.fetchgit {
        #     url=https://github.com/python-cmd2/cmd2.git;
        #     rev = "f5c904cda48c03a30b3476f3a40224226391deea";
        #     sha256 = "1226izysk99r2q8gdvi53rclfckcd5gh0qmrnvm5ycgc6qwk0li3";
        #     leaveDotGit = true;
        #     deepClone = true;
        #   };
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

    };
  };

  python3Packages = python3.pkgs;
}

