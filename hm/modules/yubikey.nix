{ config, lib, ... }:
let
  cfg = config.programs.yubikey;
in
{
  options = {
    programs.yubikey = {
      enable = lib.mkEnableOption "yubikey";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  config = lib.mkIf cfg.enable {

    services.gpg-agent = {
      #  The enable-ssh-support option configures gpg-agent to act as a replacement for the          ↳ traditional ssh-agent, allowing you to use your GPG authentication keys for SSH              ↳ logins
      enableSshSupport = false;

      # enable smartcard
      # can conflict with pcscd
      # https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
      enableScDaemon = true;
    };
  };
}
