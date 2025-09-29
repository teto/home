# created as per https://joinemm.dev/blog/yubikey-nixos-guide
{

  # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
  scdaemonSettings = {
    disable-ccid = true;
  };
}
