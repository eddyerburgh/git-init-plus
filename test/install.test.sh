#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

setUp() {
  [ -e "$HOME/Downloads/master.zip" ] && rm "$HOME/Downloads/master.zip"
  [ -e "/opt/git-init-plus-master.zip" ] && rm "/opt/git-init-plus-master.zip"
  [ -e "/opt/git-init-plus-master" ] && rm -rf "/opt/git-init-plus-master"
  [ -e "/opt/git-init-plus" ] && rm -rf "/opt/git-init-plus"
  [ -e "temp-test-dir" ] && rm -rf "temp-test-dir"
  mkdir temp-test-dir
  cd temp-test-dir || exit
}

tearDown() {
  cd .. || exit
  rm -rf test-dir
}

test_it_adds_git_init_plus_to_path() {
  "$ROOT_PATH/install.sh"
  binary_exists_in_path=false
  if hash git-init-plus 2>/dev/null; then binary_exists_in_path=true; fi
  assertTrue "$binary_exists_in_path"
}
