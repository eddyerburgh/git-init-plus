#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Initialize empty git repo
git init

# Create LICENSE
touch LICENSE

# Create README.md
touch README.md

WORKING_PATH=$(pwd)

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

# Get options
while getopts l: option
do
  case "${option}"
  in
    l) license=${OPTARG};;
  esac
done

if [ "$license" ]; then
  cat "$WORKING_PATH/licenses/MIT.txt" >> "$SCRIPT_PATH/LICENSE"
fi

