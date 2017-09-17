#!/usr/bin/env bash
set -e

readonly TMP_DIR="/tmp/${SCRIPT_NAME}.$RANDOM.$RANDOM.$RANDOM.$$"

version=

gip_get_version() {
  if [[ -z $1 ]]; then
    echo "Enter new version: "
    read -r version
  else
    version=$1
  fi
}

gip_create_temp_dir() {
	(umask 077 && mkdir "${TMP_DIR}") || {
		fatal "Could not create temporary directory! Exiting."
	}
}

gip_trap_cleanup() {
  rm -rf "${TMP_DIR}"
}

gip_release() {
  npm run release:note "$version"
  cat RELEASE_NOTE.md > "${TMP_DIR}/CHANGELOG.md"
  echo "" >> "${TMP_DIR}/CHANGELOG.md"
  cat CHANGELOG.md >> "${TMP_DIR}/CHANGELOG.md"
  cat "${TMP_DIR}/CHANGELOG.md" > CHANGELOG.md

  git add CHANGELOG.md
  git commit -m "docs: update CHANGELOG"

  git tag "v{$version}"
  git push origin "refs/tags/v{$version}"
  git push origin master
  git push origin HEAD
}

gip_confirm_version() {
  read -p "Releasing $version - are you sure? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo ./test.sh
    gip_release
  fi
}

gip_get_version "$@"
gip_create_temp_dir
gip_confirm_version

trap gip_trap_cleanup EXIT INT TERM
