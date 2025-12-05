#!/bin/sh

set -x
export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
AWS_ACCESS_KEY_ID="$(pass show self-hosting/backblaze-restic-nextcloud-backup-key | head -n1)"
# TODO use my plugin
AWS_SECRET_ACCESS_KEY="$(pass show self-hosting/backblaze-restic-nextcloud-backup-key | tail -n1)"

export RESTIC_REPOSITORY_FILE=~/.config/sops-nix/secrets/restic/teto-bucket
# export RESTIC_PASSWORD_FILE=

$@
