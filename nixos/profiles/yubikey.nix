{ pkgs, ...}:
{
  services.pcscd.enable = true;
  services.yubikey-agent.enable = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];
}
