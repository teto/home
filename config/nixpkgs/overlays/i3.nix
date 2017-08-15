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
  neovim-dev = super.neovim.overrideAttrs (oldAttrs: {
	  name = "neovim-dev";
	  src = ~/neovim;
	});
  khal-dev = super.khal.overrideAttrs (oldAttrs: {
	  name = "khal-dev";
	  src = ~/khal;
	});
}
