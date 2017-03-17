#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

shunit2 "$SCRIPT_PATH/test/license.test.sh"
shunit2 "$SCRIPT_PATH/test/readme.test.sh"
shunit2 "$SCRIPT_PATH/test/git.test.sh"
