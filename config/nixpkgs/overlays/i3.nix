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
    extraPython3Packages = [ (super.pkgs.python36.withPackages (ps: [
      ps.neovim ps.pandas ps.pycodestyle super.pkgs.neovim-remote ps.python ]))];
    });

  neovim-local = self.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
      # unpackPhase = 
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

  networkmanager-dev = super.networkmanager.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "networkmanager-dev";
    src = super.lib.cleanSource ~/NetworkManager;
    # propagatedBuildInputs = with super.pythonPackages; oldAttrs.propagatedBuildInputs ++ [ keyring pygobject3  ];
  });

  # fcitx = super.fcitx.overrideAttrs (oldAttrs: {
  #   # todo optional
  #   # super.stdenv.lib.optionalString "${super.xkeyboard_config}"
  #   # XKB_RULES_XML_FILE

  #   prePatch = ''
  #     substituteInPlace src/module/xkb/xkb.c \
  #       --replace /usr/share/X11/xkb/rules/evdev.xml ${super.xkeyboard_config}/share/X11/xkb/rules/evdev.xml;
  #     '';

  #   cmakeFlags = builtins.concatStringsSep  "" [oldAttrs.cmakeFlags "-DXKB_RULES_XML_FILE=" "${super.xkeyboard_config}/share/X11/xkb/rules/evdev.xml\n"];
  # });
}
