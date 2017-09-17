#!/usr/bin/env bash

set -x -e

readonly SCRIPT_PATH="."

rm -rf /opt/git-init-plus/ || echo "no /opt/git-init-plus"
rm /opt/git-init-plus-master.zip || echo "no /opt/git-init-plus-maste.zip"

for test_file in test/*.test.sh; do
    shunit2 "$test_file"
done

for test_file in test/*.test.sh; do
    shellcheck "$test_file"
    [ -x "$(command -v shfmt)" ] && shfmt -i 2 -l -w "$test_file"
done

for file in *.sh; do
    shellcheck "$file"
    [ -x "$(command -v shfmt)" ] && shfmt -i 2 -l -w "$file"
done
