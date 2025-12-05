#!/bin/sh
# TODO consolidate/merge back into bin/restic-wrapper.sh ?
set -x
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_REPOSITORY_FILE
AWS_ACCESS_KEY_ID="$(pass show self-hosting/backblaze-restic-immich-backup-key/username)"
AWS_SECRET_ACCESS_KEY="$(pass show self-hosting/backblaze-restic-immich-backup-key/password)"

RESTIC_REPOSITORY_FILE="$HOME/.config/sops-nix/secrets/restic/neotokyo-immich-bucket"
# export RESTIC_PASSWORD_FILE=

# create by hand
if [ ! -f "$RESTIC_REPOSITORY_FILE" ]; then
  echo "Il faut créer ce fichier a la mano vu que c'est temporaire; on ne va pas exposer ce fichier en permanence !"
  exit 1
fi

$@
