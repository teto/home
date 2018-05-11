self: super:
let

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

  fetchGitHashless = args: super.stdenv.lib.overrideDerivation
    # Use a dummy hash, to appease fetchgit's assertions
    (super.fetchgit (args // { sha256 = super.hashString "sha256" args.url; }))
    # Remove the hash-checking
    (old: {
      outputHash     = null;
      outputHashAlgo = null;
      outputHashMode = null;
      sha256         = null;
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

  ranger = super.ranger.override ( { pythonPackages=super.python3Packages; });

   yst = super.haskellPackages.yst.overrideAttrs (oldAttrs: {
     jailbreak = true;
     # name = "yst";
      # src = super.fetchFromGitHub {
      #   owner = "jgm";
      #   repo = "yst";
      #   rev = "0.5.1.2";
      #   sha256 = "1105gp38pbds46bgwj28qhdaz0cxn0y7lfqvgbgfs05kllbiri0h";
      # };

      # TODO remove current aeson and override it
      # executableHaskellDepends = [ ];
	});

  # khal-local = super.khal.overrideAttrs (oldAttrs: {
	  # name = "khal-dev";
	  # src = ~/khal;
	# });

  offlineimap = super.offlineimap.overrideAttrs (oldAttrs: {
    # pygobject2
    # USERNAME 	echo " nix-shell -p python3Packages.secretstorage -p python36Packages.keyring -p python36Packages.pygobject3"
    propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ secretstorage keyring pygobject3  ];
  });

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

  ns3-local = if (super.pkgs ? ns-3) then super.ns-3.override {
    python = self.python3;
    enableDoxygen = true;
    build_profile = "optimized";
    # withManual = true;
    generateBindings = true;
  #   # withExamples = true;
  } else null;

  dce-local = if (super.pkgs ? dce) then (super.dce.override {
    python = self.python3;
    enableDoxygen = true;
    # withManual = true;
    generateBindings = true;
    withExamples = true;
  }).overrideAttrs(old: {
    # .lock-waf_linux_build
    # { filter, src }
    # filter is a function path: type:
    # ould keep the current one, but I kn ould keep the current one, but I kn
    # builtins.match "^\\.sw[a-z]$" baseName != null ||
    src =  super.stdenv.lib.cleanSourceWith { filter= p: t: super.stdenv.lib.cleanSourceFilter p t && baseNameOf p != "build"; src=
        (super.stdenv.lib.cleanSourceWith { filter=p: t: baseNameOf p != ".lock-waf_linux_build"; src= /home/teto/dce;});
    
      };
    
  }) else null;

  notmuch-extract-patch = super.pkgs.python36.callPackage ../notmuch-extract-patch.nix {}
  # super.pkgs.stdenv.mkDerivation {
  #   name = "notmuch-extract-patch";
  #   src = super.fetchFromGitHub {
  #     owner = "aaptel";
  #     repo = "notmuch-extract-patch";
  #     rev = "f6b282d91af581178150e36369e7fe03a9c813d4";
  #     sha256="0b8gzyv3lp9qxy2z94ncmh2k8yzwl91ws3m7v2cp232fyx6s7wp7";
  #   };
  #   buildInputs = [
  #     super.pkgs.notmuch
  #     (super.pkgs.python36.withPackages (pythonPackages: with pythonPackages; [
  #     ]))
  #   ];
  #   # unpackPhase = "true";
  #   installPhase = ''
  #     mkdir -p $out/bin
  #     cp ./notmuch-extract-patch $out/bin/
  #     # TODO eventually patchShebang
  #   '';
  # };

  mptcpanalyzer = super.python3Packages.callPackage ../mptcpanalyzer.nix {
    tshark = self.pkgs.tshark-local-stable;
    inherit (super) stdenv;
  };
  mptcpnumerics = super.python3Packages.buildPythonApplication {
	pname = "mptcpnumerics";
	version = "0.1";
    # src = fetchFromGitHub {
    #   owner = "teto";
    #   repo = "mptcpanalyzer";
    #   rev = "${version}";
    #   # sha256 = ;
    # };
    # todo filter
    # filter-src
	src =  builtins.filterSource (name: type: true) /home/teto/mptcpnumerics;
    # enableCheckPhase=false;
    doCheck = false;
    /* skipCheck */
	# buildInputs = [  stevedore pandas matplotlib  ];
    # to build the doc sphinx
    # TODO package tshark
    propagatedBuildInputs = with super.python3Packages; [ stevedore cmd2 
     pandas 
     sortedcontainers
    # we want gtk because qt is so annying on nixos
    (matplotlib.override { enableGtk3=true;})
    pulp
    pyqt5
      ];
	/* propagatedBuildInputs =  [ stevedore pandas matplotlib pyqt5 ]; */

    meta = with super.stdenv.lib; {
      description = "tool specialized for multipath TCP";
      maintainers = [ maintainers.teto ];
    };
  };


  rt-tests = super.stdenv.mkDerivation {
    name = "re-tests";
    version = "1.0";
    src = super.fetchurl {
      url = https://mirrors.edge.kernel.org/pub/linux/utils/rt-tests/rt-tests-1.0.tar.gz;
      sha256="0zzyyl5wwvq621gwjfdrpj9mf3gy003hrhqry81s1qmv7m138v5v";
    };

    nativeBuildInputs = with super.pkgs; [ numactl ];
    # prefix is not passed when installing apparently

    meta = with super.stdenv.lib; {
      homepage = https://wiki.linuxfoundation.org/realtime/documentation/howto/tools/rt-tests;
      description = "Linux latency analysis";
      license = licenses.gpl2;
      maintainers = [maintainers.teto];
      platforms = platforms.linux;
    };
  };
  # to help debug a neovim crash
  # unibilium = super.unibilium.overrideAttrs (old: {
  #   separateDebugInfo = true;
  # });
  # iperf3_lkl = super.iperf3.overrideAttrs(old: {
  # });
}
