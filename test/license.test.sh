#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)
CURRENT_YEAR=$(date +"%Y")

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

test_license_is_created()
{
  "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  exists=false
  if test -f "LICENSE"; then exists=true;fi
  assertEquals true "$exists"
}

test_mit_license_created_when_MIT_passed_as_option()
{
  mit_content=$( < "$ROOT_PATH/resources/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
 "$ROOT_PATH/git-init-plus.sh" -l MIT -n Edd -p project
  license_content=$(< "./LICENSE")
  assertEquals "$mit_content" "$license_content"
}

test_isc_license_created_when_ISC_passed_as_option()
{
  isc_content=$( < "$ROOT_PATH/resources/licenses/ISC.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  "$ROOT_PATH/git-init-plus.sh" -l ISC -n Edd -p project
  license_content=$(< "./LICENSE")

  assertEquals "$isc_content" "$license_content"
}

test_error_thrown_when_l_option_does_not_exist_in_licenses()
{
  "$ROOT_PATH/git-init-plus.sh" -l DOESNOTEXIST -n Edd -p project
   assertEquals 1 $?
}

test_error_thrown_lists_all_licences_available_in_resources()
{
  [ -e "/tmp/git-init-plus.log" ] && rm -rf "/tmp/git-init-plus.log"
  "$ROOT_PATH/git-init-plus.sh" -l DOESNOTEXIST -n Edd -p project
  licenses_list=""
  for file in $ROOT_PATH/resources/licenses/*.txt; do
    if [ ! "$licenses_list" ]; then
      licenses_list=$(basename "${file%.*}")
    else
      licenses_list="$licenses_list, $(basename "${file%.*}")"
    fi
  done
  expected_message="Invalid license passed to function. Available licenses are ${licenses_list}"
  log_message=$(cat "/tmp/git-init-plus.log")
  cat "/tmp/git-init-plus.log"
  assertEquals "${expected_message}" "${log_message}"
}

test_mit_license_created_when_no_license_option_passed()
{
  mit_content=$( < "$ROOT_PATH/resources/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  license_content=$(< "./LICENSE")
  assertEquals "$mit_content" "$license_content"
}

test_name_added_to_license_when_option_passed()
{
  mit_content=$(< "$ROOT_PATH/resources/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
 "$ROOT_PATH/git-init-plus.sh" -n "Edd Yerburgh" -p project
  contains_name=false
  if grep -q "Edd Yerburgh" ./LICENSE; then contains_name=true;fi

  assertTrue "$contains_name"
}

test_prompt_for_name_and_added_to_license()
{
  mit_content=$(< "$ROOT_PATH/resources/licenses/MIT.txt" | sed -e "s/<year>/$CURRENT_YEAR/g" )
  printf "Edd Yerburgh\n" | "$ROOT_PATH/git-init-plus.sh" -p project
  contains_name=false
  if grep -q "Edd Yerburgh" ./LICENSE; then contains_name=true;fi

  assertTrue "$contains_name"
}

test_current_year_is_added_to_license()
{
 "$ROOT_PATH/git-init-plus.sh" -n Edd -p project
  contains_name=false
  if grep -q "$(date +"%Y")" ./LICENSE; then contains_name=true;fi

  assertTrue "$contains_name"
}
