self: super:

rec {
  python = super.python.override {
     # Careful, we're using a different self and super here!
    packageOverrides = python-self: pythonsuper: {

        # mininet-python = pythonsuper.mininet-python.overrideAttrs ( oa: {
        #   src = /home/teto/mininet2;
        # });

        # alot = python-super.alot.overrideAttrs (oldAttrs: {
        #   version = "0.9";
        #   src = /home/teto/alot;
        #   # src = super.pkgs.fetchFromGitHub {
        #   #   owner = "pazz";
        #   #   repo = "alot";
        #   #   rev = "08438d56ef695883f8beb8c7515b261015c676f0";
        #   #   sha256 = "0fc0ix468n2s97p9nfdl3bxi3i9hwf60j4k0mabrnxfhladsygzm";
        #   # };
        # });

        # pandas = super.pkgs.pythonPackages.pandas.overrideAttrs {
        #   doCheck = false;
        # };
      # };
    };
  };
  pythonPackages = python.pkgs;

  python3 = super.python3.override {
     # Careful, we're using a different self and super here!
    packageOverrides = pythonself: pythonsuper: {
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

        # alot = pythonsuper.alot.overrideAttrs (oldAttrs: {
        #   version = "0.8.1";
        #   src = super.fetchFromGitHub {
        #     owner = "pazz";
        #     repo = "alot";
        #     rev = "ac3129c80d72825464eb018c7f9a02f31fc68d98";
        #     sha256 = "05rg8igg64kyamd35ds1f7rixgk48dffj0xsn2wgyq7h7g3pjrnf";
        #   };
        #   disabled = false;
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
        # pandas = super.pkgs.pythonPackages.pandas.overrideAttrs {
        #   doCheck = false;
        # };
      # };
    };
  };
  python3Packages = python3.pkgs;

}

