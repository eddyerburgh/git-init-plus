#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Logger
readonly LOG_FILE="/tmp/$(basename "$0").log"
info()    { echo "[INFO]    $@" | tee -a "$LOG_FILE" >&2 ; }
warning() { echo "[WARNING] $@" | tee -a "$LOG_FILE" >&2 ; }
error()   { echo "[ERROR]   $@" | tee -a "$LOG_FILE" >&2 ; }
fatal()   { echo "[FATAL]   $@" | tee -a "$LOG_FILE" >&2 ; exit 1 ; }

wget https://github.com/eddyerburgh/git-init-plus/archive/master.zip

info "Downloading zip from github"

[ -e /opt/git-init-master.zip ] && rm /opt/git-init-master.zip
[ -e /opt/git-init-plus ] && rm -rf /opt/git-init-plus
[ -e /opt/git-init-plus-master ] && rm -rf /opt/git-init-plus-master

mv master.zip /opt/git-init-plus-master.zip

cd /opt
unzip git-init-plus-master.zip

mv git-init-plus-master git-init-plus

ROOT_DIR=/opt/git-init-plus

chmod +x "$ROOT_DIR/git-init-plus.sh"

ln -sf "$ROOT_DIR/git-init-plus.sh" /usr/local/bin/git-init-plus

info "Success! git-init-plus is installed in /usr/local/bin
Run git-init-plus to start a new git project
If git-init-plus is no recognised as a command, add /usr/loca/bin to your PATH
"
