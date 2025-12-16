{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.swayidle = {

    # timeout <timeout> <timeout command> [resume <resume command>]
    # Execute timeout command if there is no activity for <timeout> seconds.
    # mkForce to override desktop's default timeout
    timeouts = lib.mkForce [
      {
        timeout = 5 * 60;
        # command = "${pkgs.swaylock}/bin/swaylock -fF";
        command = "${pkgs.tetos.swaylockCmd}";
      }
    ];
  };
}
