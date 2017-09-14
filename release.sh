#!/usr/bin/env bash
set -e

if [[ -z $1 ]]; then
  echo "Enter new version: "
  read -r VERSION
else
  VERSION=$1
fi

sudo ./test.sh

git push origin "refs/tags/v${VERSION}"
git push origin master
