#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_README_is_created()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh" -n Edd
  exists=false
  if test -f "README.md"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}
