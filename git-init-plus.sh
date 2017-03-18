#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#/ Usage: git-init-plus [options]
#/ Description: Init a git project, LICENSE, README and .gitignore
#/ Examples: git-init-plus -l MIT
#/ Options:
#/   -l type of license to include (defaults to MIT)
#/   -n copyright holders
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

license=
name=
# Get options from command
while getopts l:n: option
do
  case "${option}"
  in
    l) license=${OPTARG};;
    n) name=${OPTARG};;
  esac
done

# Add License content
if [ "$license" ]; then
  license_reference_file="$SCRIPT_PATH/licenses/$license.txt"
  if [ ! -e "$license_reference_file" ]; then
      error "Invalid license passed to function"
      exit 2
  fi
  cat "$license_reference_file" >> "$WORKING_PATH/LICENSE"
  info "Created $license license"

else
  cat "$SCRIPT_PATH/licenses/MIT.txt" >> "$WORKING_PATH/LICENSE"
  info "No license specified, defaulting to MIT (pass license with -l arg)"
fi

# Add name to license
if [ "$name" ]; then
  sed -i "s/<copyright holders>/$name/g" "$WORKING_PATH/LICENSE"
else
  while [[ $name == '' ]]
  do
    read -p "What is the name(s) of the copyright holder(s): " name
    sed -i "s/<copyright holders>/$name/g" "$WORKING_PATH/LICENSE"
    info "Name added to license"
  done
fi

# Add date to license
sed -i "s/<year>/$(date +"%Y")/g" "$WORKING_PATH/LICENSE"

info "Success! New project initialized"

