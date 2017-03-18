#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

test_README_is_created()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  exists=false
  if test -f "README.md"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}

test_README_title_is_added_in_lowercase_when_passed_as_options()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p ProjecT-name
  contains_name=false
  if grep -q "# project-name" ./README.md; then contains_name=true;fi

  assertTrue "$contains_name"
  cd ..
  rm -rf temp-test-dir
}

test_user_is_prompted_for_README_title_if_not_passed_as_option()
{
  mkdir temp-test-dir
  cd temp-test-dir || exit
  printf "PROJECt-name\n" | "$ROOT_PATH/git-init-plus.sh" -n Edd
  contains_title=false
  if grep -q "# project-name" README.md; then contains_title=true;fi
  cat README.md
  assertTrue "$contains_title"
  cd ..
  rm -rf temp-test-dir
}

test_README_is_written_over_if_one_already_exists()
{
  mkdir temp-test-dir
  cd temp-test-dir || exit
  touch README.md
  echo "some content" > README.md
  "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  README_CONTENT=$( cat "README.md" )
  assertEquals "$README_CONTENT" "# project"
  cd ..
  rm -rf temp-test-dir
}