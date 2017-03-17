#! /bin/sh

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

test_license_is_created()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh"
  exists=false
  if test -f "LICENSE"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}

test_mit_license_created_when_MIT_passed_as_option()
{
  mit_content=$( cat "$ROOT_PATH/licenses/MIT.txt" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -l MIT
  license_content=$(cat "./LICENSE")
  assertEquals "$mit_content" "$license_content"

  cd ..
  rm -rf temp-test-dir
}

test_isc_license_created_when_ISC_passed_as_option()
{
  isc_content=$( cat "$ROOT_PATH/licenses/ISC.txt" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh" -l ISC
  license_content=$(cat "./LICENSE")
  assertEquals "$isc_content" "$license_content"

  cd ..
  rm -rf temp-test-dir
}

test_README_is_created()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh"
  exists=false
  if test -f "README.md"; then exists=true;fi
  assertEquals true "$exists"

  cd ..
  rm -rf temp-test-dir
}
