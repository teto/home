{ config, flakeInputs, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
	android-tools
   ];
}

