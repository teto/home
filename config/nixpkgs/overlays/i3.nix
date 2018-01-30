self: super:
let

  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");

  fetchgitLocal = super.fetchgitLocal;

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
  i3-local = let i3path = ~/i3; in 
  if (builtins.pathExists i3path) then
    super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource i3path;
    })
    else null;

   # i3pystatus-local = super.i3pystatus.overrideAttrs (oldAttrs: {
	  # name = "i3pystatus-dev";
	  # src = null; # super.lib.cleanSource ~/i3pystatus;
   #    propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	# });

  # neovim-local = self.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-local";
  #     withPython = false;
  #     withPython3 = true; # pour les tests ?
  #     withRuby = true; # pour les tests ?
  #     extraPython3Packages = with self.python3Packages;[ pandas python jedi]
  #     ++ super.stdenv.lib.optionals ( self.pkgs ? python-language-server) [ self.pkgs.python-language-server ]
  #     ;
  #     # todo generate a file with the path to python-language-server ?
  #     # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  # src = super.lib.cleanSource ~/neovim;
  #     meta.priority=0;
  # });

  # neovim-master = (self.neovim-unwrapped.overrideAttrs (oldAttrs: {
	  # name = "neovim-master";
	  # version = "nightly";

  #     src = fetchGitHashless {
  #       rev = "master";
  #       url = "git@github.com:neovim/neovim.git";
  #     # src = super.fetchFromGitHub {
  #     #   owner = "neovim";
  #     #   repo = "neovim";
  #     #   rev = "nightly";
  #     #   sha256 = "1a85l83akqr8zjrhl8y8axsjg71g7c8kh4177qdsyfmjkj6siq4c";
  #     };

  #     meta.priority=0;
	# })) or null;

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
    propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });

  # networkmanager-dev = super.networkmanager.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "networkmanager-dev";
  #   src = super.lib.cleanSource ~/NetworkManager;
  #   # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  # });

  # fcitx-master = super.fcitx.overrideAttrs (oldAttrs: rec {
  #   # https://github.com/fcitx/fcitx/issues/367#event-1277674192
  #   version = "master";
  #   # src = fetchGitHashless {
  #   #   url="git@github.com:fcitx/fcitx5.git";
  #   #   rev = "b2143f10426ee5115cfa655abfa497b57c2c0fdb";
  #   #   sha256 = "0pf0dvmm0xiyzdhj67wizi7wczm7dvlznn6r9kp10zpy0v7g7gg3";
  #     src = super.pkgs.fetchFromGitHub {
  #     owner = "fcitx";
  #     repo = "fcitx";
  #     rev = "master";
  #     sha256 = "1j5wqj1zcihf171p3zc8g6sn4xy5jpcxg3wmiqn32cc6226n19kb";
  #   };
  #   SSL_CERT_FILE="${super.pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  # });

  vdirsyncer-custom = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

# fetchGitHashless
  # src = super.pkgs.fetchFromGitHub {
  #   owner="pimutils";
  #   rev="master";
  #   repo="vdirsyncer";
  #   sha256="1gfp2h7qdwa7k5dm0y6flsa19d5pqd6rrkxm42y3pbdmxf931aj0";

  # src = super.pkgs.fetchgit {
  #   fetchSubmodules = false;
  #   leaveDotGit= true;
  # #   # setuptools-scm was unable to detect version for
  #   url="https://github.com/pimutils/vdirsyncer.git";
  #   sha256="1lsksg2iw7cma0c4nhh1glvcf6219ly4cchygqpji2198mab8dpa";
  # };
    doCheck=true; # doesn't work, checkPhase still happens
    # checkPhase="echo 'ignored'";
    # we need keyring to retreive passwords etc
    # ython3.withPackages( ps: [ps.pygobject3 ])
 
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages;
            [  keyring secretstorage pygobject3 ])
    ++ [ super.pkgs.liboauth super.pkgs.gobjectIntrospection];
  });

  # nix-shell -p python.pkgs.my_stuff
  python = super.python.override {
     # Careful, we're using a different self and super here!
    packageOverrides = python-self: python-super: {
      # if (super.pkgs ? pygccxml) then null else
        # now that s wird
        # pygccxml =  super.callPackage ../pygccxml.nix {
        # pkgs = super.pkgs;
        # pythonPackages = self.pkgs.python3Packages;
        pygccxml = python-super.pythonPackages.pygccxml.overrideAttrs (oldAttrs: {
          # src=fetchGitHashless {
          #   url=file:///home/teto/pygccxml;
          # };

          src=/home/teto/pygccxml;
        });
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
        pygccxml = pythonsuper.pygccxml.overrideAttrs (oldAttrs: {
          # src=fetchGitHashless {
          #   url=file:///home/teto/pygccxml;
          # };

          src=/home/teto/pygccxml;
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

  # clang = super.clang.overrideAttrs(oldAttrs: {
  #   doCheck=false;
  # });

  # llvm_4 = super.clang.overrideAttrs(oldAttrs: {
  #   doCheck=false;
  # });

  ns-3-perso = if (super.pkgs ? ns-3) then super.ns-3.override {
  #   pkgs = self.pkgs;
    python = self.python3;
    enableDoxygen = true;
    build_profile = "optimized";
    # withManual = true;
    generateBindings = true;
  #   # withExamples = true;
  } else null;

  # pkgs = super.pkgs;
  mptcpanalyzer = super.callPackage ../mptcpanalyzer.nix {
    inherit (super.python3Packages) buildPythonApplication pandas cmd2 pyperclip matplotlib pyqt5 stevedore;
    tshark = self.pkgs.tshark-local-stable;
    inherit (super) lib;
  };

  # iperf3_lkl = super.iperf3.overrideAttrs(old: {
  # });
}
