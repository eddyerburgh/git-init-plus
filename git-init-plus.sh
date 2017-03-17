#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Create path variables
WORKING_PATH=$(pwd)
SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# Initialize empty git repo
git init

# Create LICENSE
touch LICENSE

# Create README.md
touch README.md

# Get options from command
while getopts l: option
do
  case "${option}"
  in
    l) license=${OPTARG};;
  esac
done

if [ "$license" ]; then
  cat "$SCRIPT_PATH/licenses/$license.txt" >> "$WORKING_PATH/LICENSE"
fi

