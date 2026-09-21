{ pkgs, ... }:
{

    pam = {
      u2f = {
        enable = true;
        settings = {
          # Disable to avoid the nagging message 'Insert your U2F device, then press ENTER.'
          # interactive = true;
          cue = true; # will print Please touch the device.
        };
      };

      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
        swaylock = { };
      };
    };
  services.pcscd.enable = true;
  services.yubikey-agent.enable = true;

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];
}
