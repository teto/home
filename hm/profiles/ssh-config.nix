{ config, pkgs, lib,  ... }:
{
  programs.ssh = {

    enable = true;

    matchBlocks = {
      nova = {
        host = "git.novadiscovery.net";
      };
    };
    # extraOptionOverrides
    # include path to file
    extraConfig = ''
    Include ./manual.config
    '';
  };
}
