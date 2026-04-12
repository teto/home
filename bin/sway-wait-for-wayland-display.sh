#!/bin/sh
i=1

while [ "$i" -ne 100 ]; do
  systemctl --user show-environment | grep WAYLAND_DISPLAY >/dev/null

  # Return status of grep is 0 when found 1 if not found
  status=$?

  # Break loop to skip sleep if found on first try
  if [ $status -eq 0 ]; then
    echo "Display has been found."
    break
  fi

  sleep 0.1s
  # Increment
  i=$((i + 1))
done
