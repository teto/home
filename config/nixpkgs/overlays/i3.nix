self: super:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
in
rec {
  i3-local = super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource ~/i3;
	});

   i3pystatus-local = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  src = super.lib.cleanSource ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});

  neovim = super.neovim.override ( {
    vimAlias = false;
    withPython = false;
    withPython3 = true; # pour les tests ?
    withRuby = false;
    });

  neovim-local = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
      extraPython3Packages = with self.python3Packages;[ pandas python jedi]
      ++ super.stdenv.lib.optionals ( self.pkgs ? python-language-server) [ self.pkgs.python-language-server ]
      ;
      # todo generate a file with the path to python-language-server ?
      # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  src = super.lib.cleanSource ~/neovim;
      meta.priority=0;
	});

  neovim-master = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-master";
	  version = "nightly";

      src = super.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "nightly";
        sha256 = "1a85l83akqr8zjrhl8y8axsjg71g7c8kh4177qdsyfmjkj6siq4c";
      };

      meta.priority=0;
	});


   # older versions are so broken that
   # nixops-local = super.nixopsUnstable.overrideAttrs( oldAttrs: rec {
   #   # version = "2017-09-24";
   #   version = "1.6.2";
   #   name = "nixops-${version}";
   # });

   # super.callPackage mptcpanalyzer.nix

#    haskellPackages.yst = super.haskellPackages.yst.overrideAttrs (oldAttrs: {
# 	  name = "yst";
#       src = super.fetchFromGitHub {
#         owner = "jgm";
#         repo = "yst";
#         rev = "0.5.1.2";
#         sha256 = "1105gp38pbds46bgwj28qhdaz0cxn0y7lfqvgbgfs05kllbiri0h";
#       };

#       # TODO remove current aeson and override it
#       # executableHaskellDepends = [ ];
# 	});

  # khal-local = super.khal.overrideAttrs (oldAttrs: {
	  # name = "khal-dev";
	  # src = ~/khal;
	# });

  offlineimap = super.offlineimap.overrideAttrs (oldAttrs: {
    # pygobject2
    propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });


  # tshark-dev = super.tshark.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "wireshark-dev";
	  # src = super.lib.cleanSource ~/wireshark;
  #   # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  # });
  # wireshark-master = super.wireshark.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "wireshark-master";
  #   src = fetchFromGitHub {
  #   };
  # });


  # networkmanager-dev = super.networkmanager.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "networkmanager-dev";
  #   src = super.lib.cleanSource ~/NetworkManager;
  #   # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  # });

  fcitx-master = super.fcitx.overrideAttrs (oldAttrs: rec {
    # this one is treacherous see
    # https://github.com/fcitx/fcitx/issues/367#event-1277674192
    # eg; it will try to download some files while building
    # see target spell-en-download
    version = "master";
    # src = super.pkgs.fetchFromGitHub {
    #   owner = "fcitx";
    #   repo = "fcitx";
    #   rev = "b2143f10426ee5115cfa655abfa497b57c2c0fdb";
    #   sha256 = "0pf0dvmm0xiyzdhj67wizi7wczm7dvlznn6r9kp10zpy0v7g7gg3";
    # };
    src = /home/teto/fcitx;

    # doxygen for doc 
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++  [ super.pkgs.xkeyboard_config super.pkgs.wget super.pkgs.cacert ];
    # fails when building dbus error :/
# /tmp/nix-build-fcitx-4.2.9.1.drv-0/fcitx-b2143f10426ee5115cfa655abfa497b57c2c0fdb-src/cmake/fcitx-cmake-helper.sh
    SSL_CERT_FILE="${super.pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    extraCmds = ''
    export CFLAGS="-D_DEBUG"
    '';

  });

  vdirsyncer = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

    doCheck=false; # doesn't work, checkPhase still happens
    checkPhase="echo 'ignored'";
    # we need keyring to retreive passwords etc
    # ython3.withPackages( ps: [ps.pygobject3 ])
    
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages;
            [ requests_oauthlib keyring secretstorage pygobject3 ])
    ++ [ super.pkgs.liboauth super.pkgs.gobjectIntrospection];
  });

  # define it only if ns3 exists
  # dce = super.stdenv.lib.optional (super.pkgs.ns3 != null) super.callPackage /home/teto/dce { pkgs = super;  };

  # castxml = super.stdenv.lib.optional (!(super.pkgs ? castxml)) super.callPackage ../castxml.nix { pkgs = super.pkgs;  };
  # xl2tpd = super.xl2tpd.overrideAttrs ( oldAttrs : rec {
  #   makeFlags = oldAttrs ++ [ "-DUSE_KERNEL" ];
  # });

  # msmtp = super.msmtp.overrideAttrs(oldAttrs: rec {

  #   # postBuild
# # makeWrapper $out/bin/foo $wrapperfile --set FOOBAR baz
  #   # we need keyring to retreive passwords etc
  #   propagatedBuildInputs = with super.pkgs.python3Packages; [ requests_oauthlib keyring secretstorage ] ++ [ super.pkgs.liboauth ];
  # });



  # nix-shell -p python.pkgs.my_stuff
  python = super.python.override {
     # Careful, we're using a different self and super here!
    packageOverrides = self: super: {
      # if (super.pkgs ? pygccxml) then null else
        pygccxml =  super.callPackage ../pygccxml.nix {
        # pkgs = super.pkgs;
        # pythonPackages = self.pkgs.python3Packages;
        pandas = super.pkgs.pythonPackages.pandas.overrideAttrs {
          doCheck = false;
        };
      };
    };
  };
  pythonPackages = python.pkgs;

  ns-3-perso = if (super.pkgs ? ns-3) then super.ns-3.override {
  #   pkgs = self.pkgs;
    python = self.pkgs.pythonPackages.python;
    enableDoxygen = true;
    build_profile = "optimized";
    # withManual = true;
  #   # generateBindings = true;
  #   # withExamples = true;
  #   # pygccxml = self.pythonPackages.pygccxml;
  } else null;
  dce = if (super.pkgs ? ns3) then super.callPackage ../dce.nix { pkgs = super.pkgs;  } else null;


  # pkgs = super.pkgs;
  mptcpanalyzer = super.callPackage ../mptcpanalyzer.nix {};


  mptcp-local = super.pkgs.linux_mptcp.overrideAttrs (old: {
    NIX_DEBUG=8;
    src= super.lib.cleanSource /home/teto/mptcp;
  });
}
