#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")

shunit2 "$SCRIPT_PATH/test/license.test.sh"
shunit2 "$SCRIPT_PATH/test/readme.test.sh"
shunit2 "$SCRIPT_PATH/test/git.test.sh"

shellcheck "$SCRIPT_PATH/test/license.test.sh"
shellcheck "$SCRIPT_PATH/test/readme.test.sh"
shellcheck "$SCRIPT_PATH/test/git.test.sh"

shellcheck "$SCRIPT_PATH/git-init-plus.sh"