#!/usr/bin/env bash
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

# Get options from command
license=
name=
project_name=
while getopts l:n:p: option
do
  case "${option}"
  in
    l) license=${OPTARG};;
    n) name=${OPTARG};;
    p) project_name=${OPTARG};;
  esac
done

# Initialize empty git repo
git init

# Create LICENSE
touch LICENSE
LICENSE="$WORKING_PATH/LICENSE"

# Add License content
if [ "$license" ]; then
  license_reference_file="$SCRIPT_PATH/resources/licenses/$license.txt"
  if [ ! -e "$license_reference_file" ]; then
      error "Invalid license passed to function"
      exit 2
  fi
  cat "$license_reference_file" >> "$LICENSE"
  info "Created $license license"

else
  cat "$SCRIPT_PATH/resources/licenses/MIT.txt" >> "$LICENSE"
  info "No license specified, defaulting to MIT (pass license with -l arg)"
fi

# Add name to license
if [ "$name" ]; then
  sed -i "s/<copyright holders>/$name/g" "$LICENSE"
else
  while [[ $name == '' ]]
  do
    read -p "What is the name(s) of the copyright holder(s):" name
  done
  sed -i "s/<copyright holders>/$name/g" "$LICENSE"
  info "Name added to license"
fi

# Add date to license
sed -i "s/<year>/$(date +"%Y")/g" "$LICENSE"

# Create README.md
[ -e README.md ] && rm README.md
touch README.md
README="$WORKING_PATH/README.md"

# Add project name as title of README
if [ "$project_name" ]; then
  echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" > "$README"
else
  while [[ $project_name == '' ]]
  do
    read -p "What is the name your project (added as title to README):" project_name
  done
  echo "# $(tr '[:upper:]' '[:lower:]' <<<"$project_name")" > "$README"
  info "Title added to README"
fi

info "Success! New project initialized"
