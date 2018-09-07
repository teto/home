self: super:
let
	# src =  builtins.filterSource (name: type: true) /home/teto/mptcpanalyzer;
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");

  fetchgitLocal = super.fetchgitLocal;

  # Get the commit ID for the given ref in the given repo
  # latestGitCommit = { url, ref ? "HEAD" }:
  #   runCommand "repo-${sanitiseName ref}-${sanitiseName url}"
  #     {
  #       # Avoids caching. This is a cheap operation and needs to be up-to-date
  #       version = toString currentTime;
  #       # Required for SSL
  #       GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  #       buildInputs = [ git gnused ];
  #     }
  #     ''
  #       REV=$(git ls-remote "${url}" "${ref}") || exit 1
  #       printf '"%s"' $(echo "$REV"        |
  #                       head -n1           |
  #                       sed -e 's/\s.*//g' ) > "$out"
  #     '';
  # fetchLatestGit = { url, ref ? "HEAD" }@args:
  #   with { rev = import (latestGitCommit { inherit url ref; }); };
  #   fetchGitHashless (removeAttrs (args // { inherit rev; }) [ "ref" ]);
in
rec {

  
  termite-unwrapped = super.termite-unwrapped.overrideAttrs(oa: {

    
    postBuild = ''
      substituteInPlace termite.terminfo \
        --replace "smcup=\E[?1049h," "smcup=\E[?1049h\E[22;0;0t," \
        --replace "rmcup=\E[?1049l," "rmcup=\E[?1049l\E[23;0;0t"
    '';
  });


  i3-local = let i3path = ~/i3; in 
  if (builtins.pathExists i3path) then
    super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource i3path;
    })
    else null;

   i3pystatus-perso = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  # src = null; # super.lib.cleanSource ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});

  # ranger = super.ranger.override ( { pythonPackages=super.python3Packages; });

   yst = super.haskellPackages.yst.overrideAttrs (oldAttrs: {
     jailbreak = true;
  });

  # offlineimap = super.offlineimap.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   # USERNAME 	echo " nix-shell -p python3Packages.secretstorage -p python36Packages.keyring -p python36Packages.pygobject3"
  #   propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ secretstorage keyring pygobject3  ];
  # });

  vdirsyncer-custom = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

    doCheck=true; # doesn't work, checkPhase still happens
 
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages;
            [  keyring secretstorage pygobject3 ])
    ++ [ super.pkgs.liboauth super.pkgs.gobjectIntrospection];
  });

  # nix-shell -p python.pkgs.my_stuff
  python = super.python.override {
     # Careful, we're using a different self and super here!
    packageOverrides = python-self: python-super: {


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
        #     rev = "5b00a4ecd30d21ceeebb16eefbed4c48cfe3ba4a";
        #     sha256 = "05rg8igg64kyamd35ds1f7rixgk48dffj0xsn3wgyq7h7g3pjrnf";
        #   };
        #   disabled = false;
        # });


        # look for matching wcwidth
        cmd2-next = pythonsuper.cmd2.overrideAttrs (oldAttrs: {
          version = "0.9.1";
          src = super.fetchFromGitHub {
            owner = "python-cmd2";
            repo = "cmd2";
            rev = "0.9.1";
            sha256 = "1v1isbx9sb828nazcn4k1wd279s6swhcv8mj9fspx0frqlfq0pcy";
          };
        });


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

  protocol-local = super.protocol.overrideAttrs (oldAttrs: {
    src=/home/teto/protocol;
  });

  # nixVeryUnstable = super.nixUnstable.overrideAttrs(o: {
  #   src = fetchGit https://github.com/NixOS/nix;
  #   nativeBuildInputs = with super.pkgs; (o.nativeBuildInputs or []) ++ [
  #     autoreconfHook autoconf-archive bison flex libxml2 libxslt
  #     docbook5 docbook5_xsl
  #   ];
  #   buildInputs = (o.buildInputs or []) ++ [ boost ];
  # });


  nixops-dev = super.nixops.overrideAttrs ( oa: {
    # src = super.fetchFromGitHub {
    #   owner = "teto";
    #   repo = "nixops";
    #   rev = "7c71333a3ff6dc636d0b2547f07b105571a3027b";
    #   sha256 = "0fc0ix468n2s97p9nfdl3bxi3i9hwf60j4k2mabrnxfhladsygzm";
    # };
    # version = "1.7";
    name = "nixops-dev";
    # version = "
    src = builtins.fetchGit {
      url = /home/teto/nixops;
      # rev = "7c71333a3ff6dc636d0b2547f07b105571a3027b";
    };
  });

  # iperf3_lkl = super.iperf3.overrideAttrs(old: {
  # });
}
