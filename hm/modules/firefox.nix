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

      mutableProfilesIni = lib.mkEnableOption "Mutable profiles.ini";
    };

    # TODO add/configure router mappings url -> profile
  };

  config = lib.mkMerge [
    {
      # le truc c'est que ca c'est par profil !
      # programs.firefox.search.engines = lib.mkIf cfg.addMySearchEngines searchEngines;

      # setup by default some stuff
      programs.firefox.languagePacks = [
        "fr-FR"
        "jp-JP"
        "en-GB"
        # 5840
      ];

      programs.firefox.policies = lib.firefox.commonPolicies // {
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
    (
      let
        profilePath = cfg.configPath;
        # "/home/${username}/.mozilla/firefox";
        # configPath = "${config.xdg.configHome}/mozilla/firefox";

      in
      lib.mkIf cfg.mutableProfilesIni {

        home.activation = {
          makeProfilesIniWritable =
            lib.hm.dag.entryAfter [ "writeBoundary" ]
              # bash
              ''
                ini="${profilePath}/profiles.ini"
                bak="${profilePath}/profiles.ini.home-manager.backup" # or whatever you use as backupFileExtension

                # prevent failing on initial run
                if [ ! -e "$ini" ]; then
                  touch "$ini"
                fi

                if [ ! -f "$bak" ]; then
                  cp -L -- "$ini" "$bak" 
                fi

                mv -f -- "$bak" "$ini"
                chmod +w "$ini"
              '';
        };

      }
    )
  ];
}
