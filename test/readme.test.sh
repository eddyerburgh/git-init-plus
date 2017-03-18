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

test_README_title_is_added_when_passed_as_options()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p project-name
  contains_name=false
  if grep -q "# project-name" ./README.md; then contains_name=true;fi

  assertTrue "$contains_name"
  cd ..
  rm -rf temp-test-dir
}
