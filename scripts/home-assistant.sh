#!/bin/sh
set -x
curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer ${HASS_TOKEN}" \
  -d '{"entity_id": "light.lampe_chevet_fenetre_light" }' \
   http://localhost:8123/api/services/switch/turn_off

# "type": "get_services"
# http://localhost:8123/api/services
   # http://localhost:8123/api/services/switch/turn_off

