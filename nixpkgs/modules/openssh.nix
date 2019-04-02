{ config, pkgs, lib, ... }:
{

  services.openssh = {
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
    permitRootLogin = "prohibit-password";
    # needed since default is true !
    passwordAuthentication = false;
    forwardX11 = true;
    enable = true;
    challengeResponseAuthentication = false;
    # authorizedKeysFiles
    # authorizedKeys = { }

    # hostKeys to generate keys
    # 
  };
}
