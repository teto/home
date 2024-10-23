

{ config, lib, pkgs, ... }:
let
cfg = config.programs.neovim;
in
{
  options = {
  };

  
programs.neovim = {
    config = mkOption {
      type = types.nullOr types.lines;
      description = "Script to configure this plugin. The scripting language should match type.";
      default = null;
    };

}
  extraConfig = ''
    Defaults        passprompt="[sudo] password for %p: ", timestamp_timeout=360, timestamp_type=global
  '';

}


