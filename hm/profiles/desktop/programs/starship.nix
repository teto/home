
{ lib, ... }:
  # don't enable it since it will override my zle-keymap-select binding
  # programs.starship = 
  {
    enable = lib.mkForce true;
    enableZshIntegration = true;
    enableBashIntegration = lib.mkForce false;
    # settings = {};
  }

