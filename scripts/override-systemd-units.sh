#!/usr/bin/env bash

# `sudo systemd-creds setup` creates `/var/lib/systemd/credential.secret` in absence of TPM 
# that can be used to encrypt things
# I dont want my passwords to be available:
# - in cleartext on disk
# - cyphered in my repo 
#
# I move these passwords from 
# this will generate a cyphered form of them 
#


# check the nix files for 
#    LoadCredential="fastmail_perso:/home/teto/home/secrets/mail.secret";
# to find what files to generates
# mbsync


# ... encrypt input|- output|-
#     Loads the specified (unencrypted plaintext) input credential file, encrypts it and writes the (encrypted ciphertext) output to the specified target credential file. The resulting file may be referenced in the LoadCredentialEncrypted=
#     setting in unit files, or its contents used literally in SetCredentialEncrypted= settings.
#
#            --pretty, -p
 # When specified with encrypt controls whether to show the encrypted credential as SetCredentialEncrypted= setting that may be pasted directly into a unit file. Has effect only when used together with --name= and "-" as the output file.

pass show perso/fastmail_mc/password | sudo systemd-creds encrypt --name=fastmail_perso --pretty - secrets/mail.secret

# TODO chown the file ?
