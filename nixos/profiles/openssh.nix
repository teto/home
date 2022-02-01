{ config, pkgs, lib, ... }:
{

  services.openssh = {
    enable = true;
    # kinda experimental
    # services.openssh.banner = "Hello world";

    allowSFTP = true; # for sshfs edit
    # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
    permitRootLogin = "prohibit-password";
    # needed since default is true !
    passwordAuthentication = false;
    forwardX11 = true;
    kbdInteractiveAuthentication = false;
    logLevel = "VERBOSE";
    # listenAddresses = [
    #   { addr = "0.0.0.0"; port = 64022; }
    # ];
    ports = [ 12666 ];
    startWhenNeeded = true;
    # authorizedKeysFiles = [
    #   "~/.ssh/id_rsa.pub"
    # ];
    # authorizedKeys = { }

    # hostKeys to generate keys
    # hostKeys

  };
}
