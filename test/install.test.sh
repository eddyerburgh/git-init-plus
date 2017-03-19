#!/usr/bin/env bash

ROOT_PATH=$(pwd -P)

setUp()
{
  [ -e "$HOME/Downloads/master.zip" ] && rm "$HOME/Downloads/master.zip"
  [ -e "/opt/git-init-plus-master.zip" ] && rm "/opt/git-init-plus-master.zip"
  [ -e "/opt/git-init-plus-master" ] && rm -rf "/opt/git-init-plus-master"
  [ -e "/opt/git-init-plus" ] && rm -rf "/opt/git-init-plus"
  [ -e "test-dir" ] && rm -rf "test-dir"
  mkdir test-dir
  cd test-dir
}

tearDown()
{
    cd ..
    rm -rf test-dir
}

test_it_adds_git_init_plus_to_path()
{
  "$ROOT_PATH/install.sh"
  binary_exists_in_path=false
  if hash git-init-plus 2>/dev/null; then binary_exists_in_path=true;fi
  assertTrue "$binary_exists_in_path"
}

test_it_requires_prompt_to_delete_git_init_zip_in_opt()
{
  ZIP_FILE="/opt/git-init-plus-master.zip"
  touch "$ZIP_FILE"
  echo "Content" > "$ZIP_FILE"
  mkdir test-dir
  cd test-dir
  printf "n" | "$ROOT_PATH/install.sh"

  zip_not_replaced=false
  if grep -q "Content" "$ZIP_FILE"; then zip_not_replaced=true;fi
  assertEquals true "$zip_not_replaced"
}

test_it_requires_prompt_to_delete_git_init_master_dir_in_opt()
{
  GIT_INIT_MASTER_DIR="/opt/git-init-plus-master"
  mkdir "$GIT_INIT_MASTER_DIR"
  touch "$GIT_INIT_MASTER_DIR/example"
  echo "Content" > "$GIT_INIT_MASTER_DIR/example"
  mkdir test-dir
  cd test-dir
  printf "n" | "$ROOT_PATH/install.sh"

  file_not_replaced=false
  if grep -q "Content" "$GIT_INIT_MASTER_DIR/example"; then file_not_replaced=true;fi
  assertEquals true "$file_not_replaced"
}

test_it_requires_prompt_to_delete_git_init_dir_in_opt()
{
  GIT_INIT_DIR="/opt/git-init-plus"
  mkdir "$GIT_INIT_DIR"
  touch "$GIT_INIT_DIR/example"
  echo "Content" > "$GIT_INIT_DIR/example"
  mkdir test-dir
  cd test-dir
  printf "n" | "$ROOT_PATH/install.sh"

  file_not_replaced=false
  if grep -q "Content" "$GIT_INIT_DIR/example"; then file_not_replaced=true;fi
  assertEquals true "$file_not_replaced"
}