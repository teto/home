{
  config,
  lib,
  pkgs,
  ...
}:
{

  enable = true;

  settings = {
    "general.useragent.override" = "";
    "privacy.donottrackheader.enabled" = true;
  };

  profiles = {
    first = {
      isDefault = true;
      withExternalGnupg = true;
      userChrome = ''
        * { color: blue !important; }
      '';
      userContent = ''
        * { color: red !important; }
      '';
      extraConfig = ''
        user_pref("mail.html_compose", false);
      '';
    };

    # second.settings = {
    #   "second.setting" = "some-test-setting";
    #   second.nested.evenFurtherNested = [ 1 2 3 ];
    # };
  };

}
