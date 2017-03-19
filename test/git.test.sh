#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

setUp()
{
  [ -e "temp-test-dir" ] && rm -rf "temp-test-dir"
  mkdir temp-test-dir
  cd temp-test-dir  || exit
}

tearDown()
{
    cd ..
    rm -rf temp-test-dir
}

test_user_is_promted_to_overwrite_if_git_already_exists()
{
  git init
  touch .git/example
  printf "n" | "$ROOT_PATH/git-init-plus.sh" -n Edd  -p project
  original_file_exists=false
  if test -f ".git/example"; then original_file_exists=true;fi
  assertTrue "$original_file_exists"
}

test_git_is_initialized()
{
  "$ROOT_PATH/git-init-plus.sh" -n Edd  -p project
  exists=false
  if test -f "./.git/hooks/commit-msg.sample"; then exists=true;fi
  assertEquals true "$exists"
}
