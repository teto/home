#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID=$(pass show self-hosting/backblaze-restic-backup-key/username)
export AWS_SECRET_ACCESS_KEY=$(pass show self-hosting/backblaze-restic-backup-key/password)
export RESTIC_REPOSITORY_FILE=/run/secrets/restic/teto-bucket
