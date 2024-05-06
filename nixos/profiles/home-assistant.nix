{ config, lib, pkgs, ... }:
{

  # for android development
  services.home-assistant = {
    enable = true;
	openFirewall = true;

    # subset of package.extraComponents ?!
	extraComponents = [
		"default_config"
		"deconz" # interface for zigbee conbee II
		# "esphome"
		"hue"
		"emulated_hue"
        "homeassistant_yellow"

	];

    package = pkgs.home-assistant.override {
	  extraPackages = python3Packages: with python3Packages; [
        numpy
		psycopg2
	  ];
	  # look at https://www.home-assistant.io/integrations/
	  extraComponents = [
        "recorder" # to plot history of devices
		"default_config"  # metapackage
        "homeassistant_yellow"  # metapackage
		"deconz" # interface for zigbee conbee II
		# "esphome"
		"hue"
		"emulated_hue"
        "meteo_france"
		# "met"
	  ];
	};


    # TODO add whisper
    config = {

      # bluetooth = {};  # NO
      default_config = {};  # enables several default components
      # map = {};  # show a local map
      network = {};
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
      network = {};

      # https://www.home-assistant.io/integrations/recorder/
      recorder = {}; # sqlite by default
      history = {};
      logbook = {};
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
    };
	
	# so that it can be overriden from the web interface 
	configWritable = true;

	# /var/lib/hass/configuration.yaml: Secret elevation not defined
  };


  # services.deconz.enable
  # with my conbee 2 key
  services.zigbee2mqtt = {
   enable = true;
   # https://www.zigbee2mqtt.io/information/configuration.html
   # settings

  };

  environment.systemPackages = [
    pkgs.home-assistant-cli
  ];
}

