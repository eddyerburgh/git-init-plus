#! /bin/sh

ROOT_PATH=$(pwd -P)
CURRENT_YEAR=$(date +"%Y")

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
  mit_content=$( < "$ROOT_PATH/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -l MIT
  license_content=$(< "./LICENSE")
  assertEquals "$mit_content" "$license_content"

  cd ..
  rm -rf temp-test-dir
}

test_isc_license_created_when_ISC_passed_as_option()
{
  isc_content=$( < "$ROOT_PATH/licenses/ISC.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
  "$ROOT_PATH/git-init-plus.sh" -l ISC
  license_content=$(< "./LICENSE")

  assertEquals "$isc_content" "$license_content"

  cd ..
  rm -rf temp-test-dir
}

test_error_thrown_when_l_option_does_not_exist_in_licenses()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -l DOESNOTEXIST
  assertEquals 2 $?

  cd ..
  rm -rf temp-test-dir
}

test_mit_license_created_when_no_license_option_passed()
{
  mit_content=$( < "$ROOT_PATH/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh"
  license_content=$(< "./LICENSE")
  assertEquals "$mit_content" "$license_content"

  cd ..
  rm -rf temp-test-dir
}

test_name_added_to_license_when_option_passed()
{
  mit_content=$(< "$ROOT_PATH/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh" -n "Edd Yerburgh"
  contains_name=false
  if grep -q "Edd Yerburgh" ./LICENSE; then contains_name=true;fi

  assertTrue "$contains_name"

  cd ..
  rm -rf temp-test-dir
}

test_current_year_is_added_to_license()
{
  mkdir temp-test-dir
  cd temp-test-dir  || exit
 "$ROOT_PATH/git-init-plus.sh"
  contains_name=false
  if grep -q "$(date +"%Y")" ./LICENSE; then contains_name=true;fi

  assertTrue "$contains_name"

  cd ..
  rm -rf temp-test-dir
}
