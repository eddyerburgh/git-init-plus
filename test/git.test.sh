#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_user_is_promted_to_overwrite_if_git_already_exists()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  git init
  touch .git/example
  printf "n" | "$ROOT_PATH/git-init-plus.sh" -n Edd  -p project
  original_file_exists=false
  if test -f ".git/example"; then original_file_exists=true;fi
  assertTrue "$original_file_exists"

  cd ..
  rm -rf temp-test-dir
}

test_git_is_initialized()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh" -n Edd  -p project
  exists=false
  if test -f "./.git/hooks/commit-msg.sample"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}
