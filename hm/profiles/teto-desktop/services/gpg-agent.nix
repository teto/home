{ pkgs, ... }:
{
  enable = true;
  # used to be disabled , enabled for yubikey
  enableSshSupport = true;

  # enable smartcard
  # can conflict with pcscd
  # https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
  enableScDaemon = true;

  # should be default :s
  enableBashIntegration = true;
  enableZshIntegration = true;

  defaultCacheTtl = 7200;
  # maxCacheTtl
  # grabKeyboardAndMouse= false;
  grabKeyboardAndMouse = false; # should be set to false instead
  # default-cache-ttl 60
  verbose = true;
  # --max-cache-ttl
  maxCacheTtl = 86400; # in seconds (86400 = 1 day)

  maxCacheTtlSsh = 7200;

  # todo add example
  sshKeys = null;

  pinentry.package = pkgs.pinentry-gnome3;
  # see https://github.com/rycee/home-manager/issues/908
  # could try ncurses as well
  # extraConfig = ''
  #   pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry-gnome
  # '';
  # };

  extraConfig = ''


  '';
}
