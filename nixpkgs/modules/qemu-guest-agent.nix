{config, pkgs, ...}:
{
  config = {
    # boot.kernelParams = [ "console=ttyS0" ];  ## Unclear if I can't see the console in the web UI because I'm missing this, or some other reason.
    # environment.systemPackages = [ pkgs.qemu ];
    # systemd.services.qemu-guest-agent = {
    #   description = "Run the QEMU Guest Agent";
    #   path = [ pkgs.qemu ];
    #   script = "qemu-ga";
    #   serviceConfig = {
    #     Restart = "always";
    #     RestartSec = 0;
    #   };
    # };
    # services.udev.extraRules = ''SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0",  TAG+="systemd" ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"'';
  };
}
