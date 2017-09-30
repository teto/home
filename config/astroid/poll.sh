#! /usr/bin/env bash
#! nix-shell -p offlineimap notmuch

# poll script for astroid

offlineimap || exit $?

notmuch new || exit $?

