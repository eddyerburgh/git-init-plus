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

test_gitignore_is_copied()
{
  gitignore_resource_content=$( cat "$ROOT_PATH/resources/.gitignore" )
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  gitignore_content=$( cat "./.gitignore")
  assertEquals "$gitignore_resource_content" "$gitignore_content"
}
