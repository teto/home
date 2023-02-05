{ config, lib, pkgs, ... }:
{

  # for android development
  # programs.adb.enable = true;
  services.home-assistant = {
    enable = true;
	# openFirewall = true;

	extraComponents = [

	];

    package = pkgs.home-assistant.override {
	  extraPackages = python3Packages: with python3Packages; [
		psycopg2
	  ];
	  extraComponents = [
		"default_config"
		"esphome"
		"met"
	  ];
	};


    config = {
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

	  # frontend must be mandatory
        frontend = {
          themes = "!include_dir_merge_named themes";
        };
		http = {
		   server_host = "0.0.0.0";
		   server_port = 8123;
		};
	  feedreader.urls = [
	   # "https://nixos.org/blogs.xml"
	  ];
    };
	
	# so that it can be overriden from the web interface 
	configWritable = true;

	# /var/lib/hass/configuration.yaml: Secret elevation not defined
  };
}

