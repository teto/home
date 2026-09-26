{
  flakeSelf,
  ...
}:
{

  imports = [
    flakeSelf.nixosProfiles.openssh
  ];

  services.openssh = {
    enable = true;
    # kinda experimental
    # ports = [ 12666 ];

    startWhenNeeded = true;

    # new format
    # settings = {
    #   LogLevel = "VERBOSE";
    #   KbdInteractiveAuthentication = false;
    #   PasswordAuthentication = false;
    #   PermitRootLogin = "no";
    # };
  };
}
