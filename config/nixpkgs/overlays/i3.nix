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
  i3-local = super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = super.lib.cleanSource ~/i3;
	});

   i3pystatus-local = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  src = super.lib.cleanSource ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});

  # else nixops keeps recompiling it
  # neovim = super.neovim.override ( {
  #   vimAlias = false;
  #   withPython = false;
  #   withPython3 = true; # pour les tests ?
  #   withRuby = false;
  #   });

  neovim-local = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
      withPython = false;
      withPython3 = true; # pour les tests ?
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

# fetchGitHashless
  # src = super.pkgs.fetchFromGitHub {
  #   owner="pimutils";
  #   rev="master";
  #   repo="vdirsyncer";
  #   sha256="1gfp2h7qdwa7k5dm0y6flsa19d5pqd6rrkxm42y3pbdmxf931aj0";

  src = super.pkgs.fetchgit {
    fetchSubmodules = false;
    leaveDotGit= true;
  #   # setuptools-scm was unable to detect version for
    url="https://github.com/pimutils/vdirsyncer.git";
    sha256="1lsksg2iw7cma0c4nhh1glvcf6219ly4cchygqpji2198mab8dpa";
  };
    doCheck=true; # doesn't work, checkPhase still happens
    # checkPhase="echo 'ignored'";
    # we need keyring to retreive passwords etc
    # ython3.withPackages( ps: [ps.pygobject3 ])
 
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages;
            [  keyring secretstorage pygobject3 ])
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
  dce = if (super.pkgs ? ns-3) then super.callPackage ../dce.nix { pkgs = super.pkgs;  } else null;


  # pkgs = super.pkgs;
  mptcpanalyzer = super.callPackage ../mptcpanalyzer.nix {
    inherit (super.python3Packages) buildPythonApplication pandas cmd2 pyperclip matplotlib pyqt5 stevedore;
    tshark = self.pkgs.tshark-local-stable;
    inherit (super) lib;
  };

  mptcpanalyzer-test = mptcpanalyzer.overrideAttrs (old: {
    # todo be careful 
    src = fetchgitLocal old.src;
    # src = fetchgitLocal "/home/teto/mptcpanalyzer";
  });

  # TODO use this platform to build the various kernels
  # this won t be used by nixops ?
  test-platform = super.platforms.pc64_simplekernel // {
    kernelAutoModules = true;
    extraConfig = super.platforms.pc64_simplekernel + ''
      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y

      PATA_MARVELL y
      SATA_SIS y
      MD_RAID0 y

      # else qemu can't see the root filesystem when launched with -kenel
      EXT4_FS y

      VIRTIO_PCI y
      VIRTIO_PCI_LEGACY y
      VIRTIO_BALLOON m
      VIRTIO_INPUT m
      VIRTIO_MMIO m

      VIRTIO_BLK y
    '';
  };

  # luarocks-perso = super.luarocks.overrideAttrs(old: {
  #   src=

  # })



  linux_4_9 = super.linux_4_9.override({
    hostPlatform=test-platform;
  });

  # to improve the config
  # make localmodconfig
  mptcp93 = super.pkgs.linux_mptcp.override ({
    # NIX_DEBUG=8;
    # maybe that works
    # configfile = /path/to/my/config
    # TODO reuse old value of extraConfig
    # check because that line is strange

    # it will append then overwrite itself ;/
  # '' + (args.extraConfig or "");
# } // args // (args.argsOverride or {}))
    # kernelAutoModules = false;
    # TODO make a new configuration light ?
    # hostPlatform=super.lib.platforms.pc64_simplekernel;
    hostPlatform=test-platform;
    extraConfig=''
      INFINIBAND n
      MMC_SDHCI n

      DEBUG_KERNEL y
      FRAME_POINTER y
      KGDB y
      KGDB_SERIAL_CONSOLE y
      DEBUG_INFO y

      MPTCP_SCHED_ADVANCED y
      MPTCP_ROUNDROBIN m
      MPTCP_REDUNDANT m

      # TODO perso ? l activer ?
      NETWORK_PHY_TIMESTAMPING n

      NET_SWITCHDEV y
      NET_TCPPROBE m

      # else qemu can't see the root filesystem when launched with -kenel
      EXT4_FS y

 VIRTIO_PCI y
 VIRTIO_PCI_LEGACY y
 VIRTIO_BALLOON m
 VIRTIO_INPUT m
 VIRTIO_MMIO m

VIRTIO_BLK y

# when run as -kernel, need to get an ip
IP_PNP y
IP_PNP_DHCP y

      '';

    # useless on the kernel branch
    # argsOverride = {
    #   # supposed  to always work
    #   modDirVersion="4.9.60+";
    # };
  });

  # mptcp-local-stable =
  mptcp-local =
  let
    # todo remove tags
    filter-src = builtins.filterSource (p: t:
    let baseName = baseNameOf p;
    in super.lib.cleanSourceFilter p t && baseName != "build" && baseName != "tags");
  in
  mptcp93.override ({
      # src= super.lib.cleanSource /home/teto/mptcp;
      modDirVersion="4.9.60+";
      name="mptcp-local";
      # TODO testing...
      hostPlatform=super.lib.platforms.pc64_simplekernel;

      # TODO might need to revisit
      ignoreConfigErrors=true;

      # configfilename = /home/teto/dotfiles/kernel_config.mptcp;
      # src= filter-src /home/teto/mptcp;
      # src= fetchgit  /home/teto/mptcp;
      # src= super.fetchgitLocal "/home/teto/mptcp";
      src = fetchGitHashless {
        # rev="owd93";
        branchName="owd93";
        # url= file:///home/teto/mptcp;
        url= "/home/teto/mptcp";
      };
      enableParallelBuilding=true;

      # if we dont want to have to regenerate it
      # configfile=

  });

  # mptcp-head = mptcp93.override ({

  # linuxPackages_mptcp = linuxPackagesFor pkgs.linux_mptcp;
  linuxPackages_mptcp-local = super.pkgs.linuxPackagesFor mptcp-local;
}
