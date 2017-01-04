#!/usr/bin/env bash
DEV=$PWD
VIMRUNTIME="$DEV/runtime" "$DEV/build/bin/nvim" "$@"
