#!/bin/sh

# egrep -c "^([[:digit:]]*)([[:space:]]*)virbr1" test.txt
# $(grep -c "$DEVICE_IFACE" "$RT_TABLE")
# res=$(grep -c "^[[:digit:]]*[[:space:]]\+$DEVICE_IFACE" "$RT_TABLE")
# "$(nix-instantiate --eval  -E 'with import <nixpkgs> {}; nixosTests.mptcp.driver.outPath')/bin/nixos-test-driver"
cmd=$(nix-build -A nixosTests.mptcp.driver ~/nixpkgs)
"$cmd/bin/nixos-test-driver"
