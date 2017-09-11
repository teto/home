self: super:
{
  i3dev = super.i3.overrideAttrs (oldAttrs: {
	  name = "i3-dev";
	  src = ~/i3;
	});
   i3pystatus-dev = super.i3pystatus.overrideAttrs (oldAttrs: {
	  name = "i3pystatus-dev";
	  src = ~/i3pystatus;
      propagatedBuildInputs = with self.python3Packages; oldAttrs.propagatedBuildInputs ++ [ pytz ];
	});
    #
  neovim-local = super.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-local";
	  src = ~/neovim;
	});

  neovim-master = super.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-master";
	  version = "nightly";

      src = super.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "nightly";
        sha256 = "1kr80q7fgndy36j7gxb9hkypjvss3l4zkakl86p5b6si9hazdjrv";
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
}
