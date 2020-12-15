{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = true;
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
    permitRootLogin = "prohibit-password";
    # needed since default is true !
    passwordAuthentication = false;
    forwardX11 = true;
    challengeResponseAuthentication = false;
    # authorizedKeysFiles
    # authorizedKeys = { }

    # hostKeys to generate keys
    # 
  };
}
