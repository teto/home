{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = true;
    allowSFTP = true; # for sshfs edit
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
    permitRootLogin = "prohibit-password";
    # needed since default is true !
    passwordAuthentication = false;
    forwardX11 = true;
    challengeResponseAuthentication = false;
    logLevel = "VERBOSE";

    startWhenNeeded = true;
    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # authorizedKeys = { }

    # hostKeys to generate keys
  };
}
