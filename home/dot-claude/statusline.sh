#!/bin/sh
# Read session info from stdin
input=$(cat)

# Extract the current working directory using jq
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

echo "📁 $CURRENT_DIR"
