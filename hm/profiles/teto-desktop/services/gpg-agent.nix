# to force reentry of the password
# gpgconf --kill gpg-agent
{ pkgs, ... }:
{
  enable = true;
  verbose = true;

  # used to be disabled , enabled for yubikey
  #  The enable-ssh-support option configures gpg-agent to act as a replacement for the traditional ssh-agent, allowing you to use your GPG authentication keys for SSH logins
  enableSshSupport = false;

  # enable smartcard
  # can conflict with pcscd
  # https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
  enableScDaemon = true;

  # should be default :s
  # enableBashIntegration = true;
  # enableZshIntegration = false;

  defaultCacheTtl = 7200;
  # maxCacheTtl
  # grabKeyboardAndMouse= false;
  grabKeyboardAndMouse = false; # should be set to false instead
  # default-cache-ttl 60
  # --max-cache-ttl
  maxCacheTtl = 86400; # in seconds (86400 = 1 day)

  maxCacheTtlSsh = 7200;

  # Which GPG keys (by keygrip) to expose as SSH keys.
  sshKeys = null;

  # wrap it into our own ?
  pinentry.package = pkgs.pinentry-gnome3;

  # see https://github.com/rycee/home-manager/issues/908
  # could try ncurses as well
  # extraConfig = ''
  #   pinentry-program ${pkgs.pinentry-gnome}/bin/pinentry-gnome
  # '';
  # };

  # 'no-allow-external-cache' also prevents pinentry/GNOME components from maintaining their own cache.
  extraConfig = ''
    no-allow-external-cache 
  '';
}
