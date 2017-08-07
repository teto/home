self: super:
{
  i3dev = super.i3.overrideAttrs (oldAttrs: {
	  name = "toto";
	  src = ~/i3;

	});
}
