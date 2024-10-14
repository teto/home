#!/bin/sh

set -x
export AWS_ACCESS_KEY_ID=$(pass show self-hosting/backblaze-restic-backup-key/username)
export AWS_SECRET_ACCESS_KEY=$(pass show self-hosting/backblaze-restic-backup-key/password)

export RESTIC_REPOSITORY_FILE=~/.config/sops-nix/secrets/restic/teto-bucket
# export RESTIC_PASSWORD_FILE=

$@
