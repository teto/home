/*
  Needs nixos/profiles/yubikey.nix as well ?
  Links
  - https://nixos.wiki/wiki/Yubikey
  - see https://joinemm.dev/blog/yubikey-nixos-guide for gpg advice
  - https://github.com/nullcopy/ykluks-tools
*/
{
  config,
  lib,
  pkgs,
  ...
}:
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

    # pam.yubico.authorizedYubiKeys = {
    # ids =
    # path =
    # };

    home.packages = with pkgs; [
      pamtester # to test yubikey
      pam_u2f # pamu2fcfg > ~/.config/Yubico/u2f_keys
      yubioath-flutter # not sure it's great yubikey-manager #
      yubikey-manager
    ];

    programs.gpg = {
      # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    #
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
