#!/bin/sh
# Taken from https://www.home-assistant.io/installation/linux
podman run -d \
  --name homeassistant \
  --privileged \
  --restart=unless-stopped \
  -e TZ='Europe/Paris' \
  -v /home/teto/home/domotique/home-assistant.yaml:/config \
  -v /run/dbus:/run/dbus:ro \
  --network=host \
  ghcr.io/home-assistant/home-assistant:stable
