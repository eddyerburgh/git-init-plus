#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

shunit2 "$SCRIPT_PATH/test/git-init-plus.test.sh"
