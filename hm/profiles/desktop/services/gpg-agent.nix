{ pkgs, ... }:
{
  enable = true;
  # used to be disabled , enabled for yubikey
  enableSshSupport = true; 

  defaultCacheTtl = 7200;
  # maxCacheTtl
  # grabKeyboardAndMouse= false;
  grabKeyboardAndMouse = false; # should be set to false instead
  # default-cache-ttl 60
  verbose = true;
  # --max-cache-ttl
  maxCacheTtl = 86400; # in seconds (86400 = 1 day)

  pinentry.package = pkgs.pinentry-gnome3;
  # see https://github.com/rycee/home-manager/issues/908
  # could try ncurses as well
  # extraConfig = ''
  #   pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry-gnome
  # '';
  # };
}
