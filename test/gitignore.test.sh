#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_gitignore_is_copied()
{
  gitignore_resource_content=$( cat "$ROOT_PATH/resources/.gitignore" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  gitignore_content=$( cat "./.gitignore")
  assertEquals "$gitignore_resource_content" "$gitignore_content"

  cd ..
  rm -rf temp-test-dir
}
