{ config, pkgs, lib,  ... }:
{

  services.polybar = {
	enable = true;
	script = "polybar bar &";
  };

}
