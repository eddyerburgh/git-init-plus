#!/usr/bin/env bash
set -uo pipefail

IFS=$'\n\t'
SCRIPT_NAME="git-init-plus"
TMP_DIR="/tmp/${SCRIPT_NAME}.$RANDOM.$RANDOM.$RANDOM.$$"

readonly LOG_FILE="/tmp/$(basename "$0").log"
info() { echo "$@" | tee -a "$LOG_FILE" >&2; }
fatal() {
	echo "$@" | tee -a "$LOG_FILE" >&2
	exit 1
}

gip_create_temp_dir() {
	(umask 077 && mkdir "${TMP_DIR}") || {
		fatal "Could not create temporary directory! Exiting."
	}
}

gip_check_dependencies_installed() {
	command -v git >/dev/null 2>&1 || { fatal "The install script requires git but it's not installed.  Aborting."; }
	command -v curl >/dev/null 2>&1 || { fatal "The install script requires curl but it's not installed.  Aborting."; }
}

gip_download_zip() {
	cd "$TMP_DIR" || exit
	curl -LOk "https://github.com/eddyerburgh/{$SCRIPT_NAME}/archive/master.zip"
}

gip_unzip() {
	cd "$TMP_DIR" || exit
	unzip master.zip
}

gip_move_to_opt() {
	mv "${TMP_DIR}/${SCRIPT_NAME}-master" "/opt/${SCRIPT_NAME}"
}

gip_create_sym_link() {
	local ROOT_DIR="/opt/${SCRIPT_NAME}"
	chmod +x "$ROOT_DIR/${SCRIPT_NAME}.sh"
	ln -sf "$ROOT_DIR/${SCRIPT_NAME}.sh" "/usr/local/bin/${SCRIPT_NAME}"
}

gip_trap_cleanup() {
	rm -rf "${TMP_DIR}"
}

gip_log_success() {
	info ""
	info "Success! ${SCRIPT_NAME} is installed in /usr/local/bin"
	info ""
	info "Enter ${SCRIPT_NAME} to start a new git project"
	info ""
	info "If ${SCRIPT_NAME} is not recognised as a command, add /usr/local/bin to your PATH"
  info ""
}

gip_install() {
	gip_check_dependencies_installed
	gip_create_temp_dir
	gip_download_zip
	gip_unzip
	gip_move_to_opt
	gip_create_sym_link
	gip_log_success
}

gip_install

trap gip_trap_cleanup EXIT INT TERM
