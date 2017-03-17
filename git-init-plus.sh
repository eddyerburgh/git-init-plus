#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Logger
readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

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
  info "created $license license"
fi

