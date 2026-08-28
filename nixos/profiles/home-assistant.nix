{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.home-assistant-cli ];

  # for android development
  services.home-assistant = {

    # subset of package.extraComponents ?!
    # extraComponents = [
    #   # "default_config"
    #   # "apple_tv" # to avoid an error, try removing it ?
    #   # "deconz" # interface for zigbee conbee II
    # ];

    package = pkgs.home-assistant.override {

      extraPackages =
        python3Packages: with pkgs.python3Packages; [
          numpy
          psycopg2
        ];
      # look at https://www.home-assistant.io/integrations/
      # pkgs/servers/home-assistant/component-packages.nix
      extraComponents = [
        "recorder" # to plot history of devices

        # removed to avoid zha
        "default_config" # metapackage
        "homeassistant_yellow" # metapackage
        "data_grand_lyon" # to fetch TCL software
        "deconz" # interface for zigbee conbee II
        # "esphome"
        # "hue"
        # "esphome"
        "emulated_hue"
        "freebox"
        "homeassistant_yellow" # brings zha
        "hue"

        "met"
        # "emulated_hue"
        "mqtt"
        "meteo_france"
        # else we get :
        # flow could not be loaded: {"message":"Invalid handler specified"}
        "wyoming" 
        "upnp" 
        # "met"
      ];
    };

    # TODO add whisper
    # backups exist at /var/lib/hass/backups/
    # https://nixos.wiki/wiki/Home_Assistant
    config = {
      assist_pipeline = {};
      # bluetooth = {};  # NO
      default_config = { }; # enables several default components
      # map = {};  # show a local map
      network = { };
      homeassistant = {
        name = "Home";
        # https://www.home-assistant.io/docs/configuration/secrets/

        # latitude = "!secret latitude";
        # longitude = "!secret longitude";
        # elevation = "!secret elevation";

        latitude = "45.764043";
        longitude = "4.835659";
        elevation = "0";
        unit_system = "metric";
        time_zone = "Europe/Paris";
      };

      # allows to connect remotely
      network = { };

      # https://www.home-assistant.io/integrations/recorder/
      recorder = { }; # sqlite by default
      history = { };
      logbook = { };
      # logbook.exclude.entities = hiddenEntities;
      system_health = { };
      system_log = { };
      mobile_app = { };
      backup = { };
      logger.default = "info";
      # Text to speech
      tts = {
        platform = "google_translate";
      };

      # THE FILE DISAPPEARED !
      # script= "!include scripts.yaml";
      # scene= "!include scenes.yaml";
      automation = "!include automations.yaml";
      # frontend must be mandatory
      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      # TODO remove this is handled from UI now ?!
      # http = {
      #   server_host = "0.0.0.0";
      #   server_port = 8123;
      # };
      # services.home-assistant.config."scene manual" = [];
      # services.home-assistant.config."scene ui" = "!include scenes.yaml";
    };

    # so that it can be overriden from the web interface
    configWritable = true;

    # /var/lib/hass/configuration.yaml: Secret elevation not defined
  };

  # If you did not create any automations through the UI,
  # Home Assistant will fail loading because the automations.yaml file does not exist yet and it will fail including it. To avoid that, add a systemd tmpfiles.d rule:
  # taken from https://wiki.nixos.org/wiki/Home_Assistant#Combine_declarative_and_UI_defined_scenes
  # TODO cp the sops secrets
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
  ];

  # services.deconz.enable
  # with my conbee 2 key

}
