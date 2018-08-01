#!/usr/bin/env sh
if [ -z $IN_NIX_SHELL ];
then
	echo "you are not in a nix-shell"
	exit 1
fi


echo $stdenv
source $stdenv/setup

if [ -z "$buildPhase" ]; then
	$buildPhase
else
	buildPhase
fi
