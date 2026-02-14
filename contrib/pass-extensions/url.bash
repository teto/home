#!/usr/bin/env bash

openurl() {
  local path="${1%/}"
  local passfile="${PREFIX}/${path}.gpg"

  set -x

  if [[ ! -f $passfile ]]; then
    echo "Error: Password file not found for ${path}"
    return 1
  fi

  local url
  url=$(pass show "$path" | grep -i '^url:' | head -n 1 | sed 's/^url:[[:space:]]*//')

  if [[ -z $url ]]; then
    echo "No URL found in password entry for ${path}"
    return 1
  fi

  echo "Opening URL: $url"
  xdg-open "$url" || open "$url" # xdg-open for Linux, open for macOS
}

function usage() {
  echo "Usage: $0 [-s] [query]"
  exit 1
}

echo "Calling url extension"
openurl "$@"
