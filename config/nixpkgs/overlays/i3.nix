self: super:
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
    extraPython3Packages = [ (super.pkgs.python36.withPackages (ps: [
       ps.pandas ps.python ]))];
    });

  neovim-local = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
      # unpackPhase = ":"; # cf https://nixos.wiki/wiki/Packaging_Software
	  src = super.lib.cleanSource ~/neovim;
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
	  src = super.lib.cleanSource ~/wireshark;
    # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
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
  #   # todo optional
  #   # super.stdenv.lib.optionalString "${super.xkeyboard_config}"
  #   # XKB_RULES_XML_FILE
  version = "master";
    src = super.pkgs.fetchFromGitHub {
      owner = "fcitx";
      repo = "fcitx";
      rev = "${version}";
      sha256 = "0d6scbs7drsj4lmvl8y9gignrnzkgr34c61694l3japmvq590nd3";
    };

    # nativeBuildInputs = [ super.pkgs.xkeyboard_config ] + oldAttrs.nativeBuildInputs;
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++  [ super.pkgs.xkeyboard_config ];

    extraCmds = ''
    export CFLAGS="-D_DEBUG"
    '';

  #   prePatch = ''
  #     substituteInPlace src/module/xkb/xkb.c \
  #       --replace /usr/share/X11/xkb/rules/evdev.xml ${super.xkeyboard_config}/share/X11/xkb/rules/evdev.xml;
  #     '';

  #   cmakeFlags = builtins.concatStringsSep  "" [oldAttrs.cmakeFlags "-DXKB_RULES_XML_FILE=" "${super.xkeyboard_config}/share/X11/xkb/rules/evdev.xml\n"];
  });

  vdirsyncer-custom = super.vdirsyncer.overrideAttrs(oldAttrs: rec {

    doCheck=false; # doesn't work, checkPhase still happens
    checkPhase="echo 'ignored'";
    # we need keyring to retreive passwords etc
    propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ (with super.pkgs.python3Packages; [ requests_oauthlib keyring secretstorage ]) ++ [ super.pkgs.liboauth ];
      # (super.pkgs.python3.withPackages (ps: [  ps.requests_oauthlib ps.keyring ps.secretstorage  ])) ];
  });

  # fcitx = super.fcitx.overrideAttrs (oldAttrs: {
  # # #   # todo optional
  # # #   # super.stdenv.lib.optionalString "${super.xkeyboard_config}"
  # # #   # XKB_RULES_XML_FILE
  #   src= /home/teto/fcitx;
  # # # cmakeFlags = ''
  # # #   -D_DEBUG
  # # #   '' + oldAttrs.cmakeFlags;

  # });
}
