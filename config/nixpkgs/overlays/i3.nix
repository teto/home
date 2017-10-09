self: super:
let
  # see https://github.com/NixOS/nixpkgs/issues/29605#issuecomment-332474682
  # In lib/sources.nix we have "cleanSource = builtins.filterSource cleanSourceFilter;"
  # TODO builtins.filterSource (p: t: lib.cleanSourceFilter p t && baseNameOf p != "build")
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
in
{
  i3dev = super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource ~/i3;
	});

   i3pystatus-dev = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  src = super.lib.cleanSource ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});
    #
  neovim = super.neovim.override ( {
    vimAlias = false;
    withPython = false;
    extraPython3Packages = with super.python3Packages;[ pandas python jedi];
    });

  neovim-local = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
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
   nixops-local = super.nixopsUnstable.overrideAttrs( oldAttrs: rec {

     # version = "2017-09-24";
     version = "1.6.2";
     name = "nixops-${version}";
     # it should be
     # src = super.lib.cleanSource ~/nixops;
   });

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

  khal-dev = super.khal.overrideAttrs (oldAttrs: {
	  name = "khal-dev";
	  src = ~/khal;
	});

  offlineimap = super.offlineimap.overrideAttrs (oldAttrs: {
    # pygobject2
    propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });

  wireshark-dev = super.wireshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "wireshark-dev";
    src = filter-cmake ~/wireshark;
    # TODO
    postBuild = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./run"
      '';
    # useless, __nixè
    # preUnpack = "echo 'hello world'; rm -rf __nix_qt5__";
    # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });


  tshark-local = super.tshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "tshark-dev";
    src = filter-cmake ~/wireshark;
    # TODO
    postBuild = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./run"
      '';
      # write in .nvimrc
    nvimrc = super.pkgs.writeText "_nvimrc" ''
        " to deal with cmake build folder
        let &makeprg="make -C build"
      '';
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


  networkmanager-dev = super.networkmanager.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "networkmanager-dev";
    src = super.lib.cleanSource ~/NetworkManager;
    # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });

  fcitx-master = super.fcitx.overrideAttrs (oldAttrs: rec {
    # this one is treacherous see
    # https://github.com/fcitx/fcitx/issues/367#event-1277674192
    # eg; it will try to download some files while building
    # see target spell-en-download
    version = "master";
    src = super.pkgs.fetchFromGitHub {
      owner = "fcitx";
      repo = "fcitx";
      rev = "${version}";
      sha256 = "0ndz5ipimfpymhx3vf4rijw3166ygk3jv4np1nahrynlxpkmf027";
    };

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++  [ super.pkgs.xkeyboard_config super.pkgs.wget super.pkgs.cacert ];

    extraCmds = ''
    export CFLAGS="-D_DEBUG"
    '';

  });

  vdirsyncer = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

    doCheck=false; # doesn't work, checkPhase still happens
    checkPhase="echo 'ignored'";
    # we need keyring to retreive passwords etc
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages; [ requests_oauthlib keyring secretstorage ]) ++ [ super.pkgs.liboauth ];
  });

  # define it only if ns3 exists
  # dce = super.stdenv.lib.optional (super.pkgs.ns3 != null) super.callPackage /home/teto/dce { pkgs = super;  };
  dce = if (super.pkgs ? ns3) then super.callPackage ../dce.nix { pkgs = super.pkgs;  } else null;
  mptcpanalyzer = super.callPackage ../mptcpanalyzer.nix { pkgs = super.pkgs;  };
}
