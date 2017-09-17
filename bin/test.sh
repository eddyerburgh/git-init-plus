#!/usr/bin/env bash

set -x -e

SCRIPT_PATH="."

rm -rf /opt/git-init-plus/ || echo "no /opt/git-init-plus"
rm /opt/git-init-plus-master.zip || echo "no /opt/git-init-plus-maste.zip"

shunit2 "$SCRIPT_PATH/test/license.test.sh"
shunit2 "$SCRIPT_PATH/test/readme.test.sh"
shunit2 "$SCRIPT_PATH/test/git.test.sh"
shunit2 "$SCRIPT_PATH/test/gitignore.test.sh"
shunit2 "$SCRIPT_PATH/test/install.test.sh"

shellcheck "$SCRIPT_PATH/test/license.test.sh"
shellcheck "$SCRIPT_PATH/test/readme.test.sh"
shellcheck "$SCRIPT_PATH/test/git.test.sh"
shellcheck "$SCRIPT_PATH/test/git.test.sh"
shellcheck "$SCRIPT_PATH/test/install.test.sh"

shellcheck "$SCRIPT_PATH/install.sh"
shellcheck "$SCRIPT_PATH/git-init-plus.sh"
