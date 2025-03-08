{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.firefox;

in
{
  options = {
    programs.firefox = {
      # mkEnableOption
      addMySearchEngines = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Add teto's favorite search engines.
        '';
      };
    };
  };
  config = lib.mkMerge [
    {
      # le truc c'est que ca c'est par profil !
      # programs.firefox.search.engines = lib.mkIf cfg.addMySearchEngines searchEngines;

      # setup by default some stuff
      languagePacks = [
        "fr-FR"
        "jp-JP"
        "en-GB"
        # 5840
      ];

      policies = {
        BlockAboutConfig = false;
        AppAutoUpdate = true;

        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;

        # DefaultDownloadDirectory
        DisableFirefoxStudies = true;
        # DisableFormHistory;
        DisablePocket = true;
        DisableTelemetry = true;
        DisplayMenuBar = "default-off";
        HardwareAcceleration = true;
        # buggy see https://github.com/nix-community/home-manager/issues/5821
        NoDefaultBookmarks = true;
        # OfferToSaveLoginsDefault =
        # TranslateEnabled =
        PDFjs = false;
        Bookmarks = { };
      };
    }
  ];
}
