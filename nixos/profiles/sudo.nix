{ config, lib, pkgs, ... }:
{
  security.sudo = {


  };

  Defaults passprompt="^G[sudo] password for %p: "
}

