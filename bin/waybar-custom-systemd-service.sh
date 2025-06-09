#!/usr/bin/env bash

# Specify your service here
SERVICE="ollama"

# Check if the service is active
if systemctl is-active --quiet "$SERVICE"; then
  STATUS="running"
else
  STATUS="stopped"
fi

# Output JSON
echo "{\"text\":\"$SERVICE: $STATUS\",\"tooltip\":\"$SERVICE is $STATUS\",\"class\":\"$STATUS\"}"
