#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: git-init-plus [options]
#/ Description: Init a git project, LICENSE, README and .gitignore
#/ Examples: git-init-plus -l MIT
#/ Options:
#/   -l type of license to include (defaults to MIT)
#/   --help: Display this help message
usage() {
    grep '^#/' "$0" | cut -c4-
    exit 0
}
expr "$*" : ".*--help" > /dev/null && usage

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
  license_reference_file="$SCRIPT_PATH/licenses/$license.txt"
  if [ ! -e "$license_reference_file" ]; then
      error "invalid license passed to function"
      exit 2
  fi

  cat "$license_reference_file" >> "$WORKING_PATH/LICENSE"
  info "created $license license"
fi

