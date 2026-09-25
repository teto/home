{
  # "z2m" (zigbee2mqtt)

  # homeassistant:
  #   enabled: true
  #   discovery_topic: homeassistant
  #   experimental_event_entities: true
  # mqtt:
  #   base_topic: zigbee2mqtt
  #   server: mqtt://localhost:1883

  services.zigbee2mqtt = {
    enable = true;
    # https://www.zigbee2mqtt.io/information/configuration.html
    settings = {
      # homeassistant = config.services.home-assistant.enable;
      # homeassistant = false;
      homeassistant = {
        enabled = true;
        #   discovery_topic: homeassistant # default
        experimental_event_entities = true; # not default
      };
      permit_join = true; # todo disable after configuration for secuirty
      serial = {
        # according to https://www.zigbee2mqtt.io/guide/adapters/#recommended
        # might need to flash the firmware
        adapter = "deconz"; # value for conbee II
        port = "/dev/ttyACM0";
        # port = null;
      };
      frontend = {
        enabled = true;
        # Optional, default 8080
        # port= 1010;
      };
      advanced = {
        log_level = "debug";
      };
    };
  };

  # needed by zigbee2mqtt, it's some kind of queue
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        # TODO set one via !secret ?
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

}
