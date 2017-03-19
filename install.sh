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

# Prompt for permission to remove any existing files/folders that are used in install
if [ -e "/opt/git-init-plus-master.zip" ]; then
  read -r -p "/opt/git-init-plus-master.zip already exists, OK to replace? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      rm /opt/git-init-plus-master.zip
      mv master.zip /opt/git-init-plus-master.zip
      ;;
    *)
      info "Install exiting. Please rename /opt/git-init-plus-master.zip and rerun install script"
      exit 2
    ;;
  esac
else
  mv master.zip /opt/git-init-plus-master.zip
fi

if [ -e "/opt/git-init-plus-master" ]; then
  read -r -p "/opt/git-init-plus-master directory already exists, OK to replace? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      rm -rf "/opt/git-init-plus-master"
      ;;
    *)
      info "Install exiting. Please rename /opt/git-init-plus-master and rerun install script"
      exit 2
    ;;
  esac
fi

if [ -e "/opt/git-init-plus" ]; then
  read -r -p "/opt/git-init-plus directory already exists, OK to replace? [y/N] " response
  case "$response" in
    [yY][eE][sS]|[yY])
      rm -rf "/opt/git-init-plus"
      ;;
    *)
      info "Install exiting. Please rename /opt/git-init-plus and rerun install script"
      exit 2
    ;;
  esac
fi

cd /opt
unzip git-init-plus-master.zip

mv git-init-plus-master git-init-plus

ROOT_DIR=/opt/git-init-plus

chmod +x "$ROOT_DIR/git-init-plus.sh"

ln -sf "$ROOT_DIR/git-init-plus.sh" /usr/local/bin/git-init-plus

info "Success! git-init-plus is installed in /usr/local/bin
Run git-init-plus to start a new git project
If git-init-plus is no recognised as a command, add /usr/local/bin to your PATH
"
