#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_it_adds_git_init_plus_to_path()
{
  [ -e "/usr/local/bin/git-init-plus" ] && rm "/usr/local/bin/git-init-plus"
  mkdir test-dir
  cd test-dir
  "$ROOT_PATH/install.sh"
  binary_exists_in_path=false
  if hash git-init-plus 2>/dev/null; then binary_exists_in_path=true;fi
  assertTrue "$binary_exists_in_path"

  cd ..
  rm -rf test-dir
}