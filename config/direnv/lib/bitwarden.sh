#!/usr/bin/env bash

function bitwarden_password_to_env() {
  local folder=$1
  shift
  local password_names=("$@")

  # Log in to Bitwarden and export the session key
  BW_SESSION=$(bw unlock --raw)

  if [ -z "$BW_SESSION" ]; then
    echo "Failed to log in to Bitwarden. Login using 'bw login'"
    exit 1
  fi

  echo "Successfully logged in to Bitwarden."

  # Retrieve the folderId for TEST_FOLDER
  FOLDER_ID=$(bw list folders --search "$folder" --session "$BW_SESSION" | jq -r '.[0].id')

  if [ -z "$FOLDER_ID" ]; then
    echo "Failed to find the folder $folder. Please check if it exists and sync if needed with 'bw sync'"
    exit 1
  fi

  # Loop through each password name
  for password_name in "${password_names[@]}"; do
    # Retrieve the itemId for the password in the folder
    ITEM_ID=$(bw list items --folderid "$FOLDER_ID" --search "$password_name" --session "$BW_SESSION" | jq -r '.[0].id')

    if [ -z "$ITEM_ID" ]; then
      echo "Failed to find the item $password_name in folder $folder. Please check if it exists and sync if needed with 'bw sync'"
      continue
    fi

    # Retrieve the password for the item
    PASSWORD=$(bw get password "$ITEM_ID" --session "$BW_SESSION")

    if [ -z "$PASSWORD" ]; then
      echo "Failed to retrieve the password for $password_name. Please check if it exists and sync if needed with 'bw sync'"
      continue
    fi

    # Export the password as an environment variable
    export "$password_name=$PASSWORD"
    echo "$password_name has been successfully retrieved and exported as an environment variable."
  done

  # Lock the Bitwarden session
  bw lock
}
