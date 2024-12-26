{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.home-assistant-cli ];

  # for android development
  services.home-assistant = {
    enable = true;
    openFirewall = true;

    # subset of package.extraComponents ?!
    extraComponents = [
      # "default_config"
      "deconz" # interface for zigbee conbee II
      # "esphome"
      "hue"
      "emulated_hue"
      "homeassistant_yellow"

    ];

    package = pkgs.home-assistant.override {

      extraPackages =
        python3Packages: with python3Packages; [
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
        "deconz" # interface for zigbee conbee II
        # "esphome"
        # "hue"

        "met"
        # "emulated_hue"
        "mqtt"
        "meteo_france"
        # "met"
      ];
    };

    # TODO add whisper
    # backups exist at /var/lib/hass/backups/
    # https://nixos.wiki/wiki/Home_Assistant
    config = {

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
      shopping_list = { };
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
      http = {
        server_host = "0.0.0.0";
        server_port = 8123;
      };
      feedreader.urls = [
        "https://www.home-assistant.io/atom.xml"
        # "https://nixos.org/blogs.xml"
      ];
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
  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
  ];

  # services.deconz.enable
  # with my conbee 2 key

  # "z2m" (zigbee2mqtt)
  services.zigbee2mqtt = {
    enable = true;
    # https://www.zigbee2mqtt.io/information/configuration.html
    settings = {
      homeassistant = config.services.home-assistant.enable;
      permit_join = true; # todo disable after configuration for secuirty
      serial = {
        # according to https://www.zigbee2mqtt.io/guide/adapters/#recommended
        # might need to flash the firmware
        adapter = "deconz"; # value for conbee II
        port = "/dev/ttyACM0";
        # port = null;
      };
      frontend = {
        # true; # starts on 8080
        # Optional, default 8080
        # 1880
        # port= 1010;
      };
      advanced = {
        log_level = "info";
      };
    };
  };

  # needed by zigbee2mqtt
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };
}
