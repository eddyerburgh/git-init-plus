#!/usr/bin/env bash
set -uo pipefail
IFS=$'\n\t'

# Logger
readonly LOG_FILE="/tmp/$(basename "$0").log"
info() { echo "$@" | tee -a "$LOG_FILE" >&2; }
fatal() {
	echo "$@" | tee -a "$LOG_FILE" >&2
	exit 1
}

gip_check_dependencies_installed() {
	command -v git >/dev/null 2>&1 || { fatal "The install script requires git but it's not installed.  Aborting."; }
	command -v curl >/dev/null 2>&1 || { fatal "The install script requires curl but it's not installed.  Aborting."; }
}

gip_download_zip() {
	curl -LOk https://github.com/eddyerburgh/git-init-plus/archive/master.zip
}

gip_remove_existing_files() {
	# Prompt for permission to remove any existing files/folders that are used in install
	if [ -e "/opt/git-init-plus-master.zip" ]; then
		read -r -p "/opt/git-init-plus-master.zip already exists, OK to replace? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			rm /opt/git-init-plus-master.zip
			mv master.zip /opt/git-init-plus-master.zip
			;;
		*)
			fatal "Install exiting. Please rename /opt/git-init-plus-master.zip and rerun install script"
			;;
		esac
	else
		mv master.zip /opt/git-init-plus-master.zip
	fi

	if [ -e "/opt/git-init-plus-master" ]; then
		read -r -p "/opt/git-init-plus-master directory already exists, OK to replace? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			rm -rf "/opt/git-init-plus-master"
			;;
		*)
			fatal "Install exiting. Please rename /opt/git-init-plus-master and rerun install script"
			;;
		esac
	fi

	if [ -e "/opt/git-init-plus" ]; then
		read -r -p "/opt/git-init-plus directory already exists, OK to replace? [y/N] " response
		case "$response" in
		[yY][eE][sS] | [yY])
			rm -rf "/opt/git-init-plus"
			;;
		*)
			fatal "Install exiting. Please rename /opt/git-init-plus and rerun install script"
			;;
		esac
	fi
}

gip_unzip() {
	cd /opt || exit
	unzip git-init-plus-master.zip

	mv git-init-plus-master git-init-plus
}

gip_create_sym_link() {
	ROOT_DIR=/opt/git-init-plus

	chmod +x "$ROOT_DIR/git-init-plus.sh"

	ln -sf "$ROOT_DIR/git-init-plus.sh" /usr/local/bin/git-init-plus
}

gip_install() {
	gip_check_dependencies_installed
	gip_download_zip
	gip_remove_existing_files
	gip_unzip
	gip_create_sym_link
	info "Success! git-init-plus is installed in /usr/local/bin
  Run git-init-plus to start a new git project
  If git-init-plus is no recognised as a command, add /usr/local/bin to your PATH
  "
}

gip_install
