#!/usr/bin/env bash

# EDIT THIS VARIABLE
# You can get this by running `ddcutil detect -t | grep -o "i2c-[0-9]\+$" | grep -o "[0-9]$" | sort | uniq`
DDC_I2C_BUSES=(13 15)
MONITOR_MODEL_RE="model\(([A-Za-z0-9_ -]+)\)"
INPUT_SOURCE_RE="60\(([A-Za-z0-9_ -]+)\)"
INPUT_SOURCE_VCP_RE="x([A-Za-z0-9]+)"
# Names for VCP 0x60 (input source)
INPUT_SOURCE_NAMES=(
  ""
  "VGA-1" "VGA-2"
  "DVI-1" "DVI-2"
  "Composite video 1" "Composite video 2"
  "S-Video-1" "S-Video-2"
  "Tuner-1" "Tuner-2" "Tuner-3"
  "Component video 1" "Component video 2" "Component video 3"
  "DP-1" "DP-2"
  "HDMI-1" "HDMI-2"
)

select_monitor() {
  # get the current connector on sway
  if [ -n "$SWAYSOCK" ]; then
    # current focused output
    CURRENT_CONNECTOR=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true).name')
  fi

  # print info on each monitor
  for i in ${!DDC_I2C_BUSES[@]}; do
    id=${DDC_I2C_BUSES[$i]}

    capabilities=$(ddcutil capabilities -b "$id" -t)
    model="Unknown model"
    # parse the model out of the capabilities string
    if [[ $capabilities =~ $MONITOR_MODEL_RE ]]; then
      model=${BASH_REMATCH[1]}
    fi

    # DRM connector
    connector="Unknown connector"
    connector_path=$(find /sys/class/drm/*/ -maxdepth 1 -name "i2c-$id")
    if [ -n "$connector_path" ]; then
      connector=$(basename "$(dirname "$connector_path")" | sed 's/card1-//')
    fi

    echo -en "$model ($connector)\0meta\x1f$id\x1finfo\x1f$id"

    # activate the current focused display row
    if [ "$CURRENT_CONNECTOR" = "$connector" ]; then
      echo -en "\x1factive\x1ftrue"
    fi

    echo
  done

  echo -e "\0prompt\x1fSelect monitor"
  echo -e "\0no-custom\x1ftrue"
}

select_input() {
  capabilities=$(ddcutil capabilities -b "$1" -t)
  # parse the available input sources out of the capabilities string
  if [[ $capabilities =~ $INPUT_SOURCE_RE ]]; then
    source_ids=${BASH_REMATCH[1]}

    # parse the active input source
    active_input_source_raw=$(ddcutil getvcp -b $1 60 -t)
    if [[ $active_input_source_raw =~ $INPUT_SOURCE_VCP_RE ]]; then
      active_input_source=${BASH_REMATCH[1]}
    fi

    for source_id in ${source_ids[@]}; do
      source_name=${INPUT_SOURCE_NAMES[$((16#$source_id))]}
      echo -en "$source_name\0meta\x1f$source_id\x1finfo\x1f$source_id"

      # activate the current input source row
      if [ "$active_input_source" = "$source_id" ]; then
        echo -en "\x1factive\x1ftrue"
      fi

      echo
    done

    echo -e "\0prompt\x1fSelect input source"
    echo -e "\0no-custom\x1ftrue"
    # data = input id
    echo -e "\0data\x1f$1"
  fi
}

set_input() {
  ddcutil setvcp -b "$1" 60 "0x$2"
}

# initial call
if [ "$ROFI_RETV" -eq 0 ]; then
  select_monitor
# monitor + input selected
elif [ -n "$ROFI_DATA" ]; then
  # monitor id, input id
  set_input $ROFI_DATA $ROFI_INFO
else
  select_input $ROFI_INFO
fi
