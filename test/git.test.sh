#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_git_is_initialized()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh"
  exists=false
  if test -f "./.git/hooks/commit-msg.sample"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}
